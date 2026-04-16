FROM python:3.11

# 安装 Node.js （满足 >=18）及必要工具
# Note: default nodejs from apt may be outdated; using nodejs from nodesource for >=18
RUN apt-get update \
  && apt-get install -y --no-install-recommends curl \
  && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get install -y --no-install-recommends nodejs \
  && rm -rf /var/lib/apt/lists/*

# 从 uv 官方镜像复制 uv
COPY --from=ghcr.io/astral-sh/uv:0.9.26 /uv /uvx /bin/

WORKDIR /app

# 先复制依赖描述文件以利用缓存
COPY package.json package-lock.json ./
COPY frontend/package.json frontend/package-lock.json ./frontend/
COPY backend/pyproject.toml backend/uv.lock ./backend/

# 安装依赖（Node + Python）
# --frozen ensures reproducible installs; omit --prefix workaround if frontend has its own lockfile
RUN npm ci \
  && npm ci --prefix frontend \
  && cd backend && uv sync --frozen

# 复制项目源码
COPY . .

# Expose backend (5001) and frontend dev server (3000)
EXPOSE 3000 5001

# Set a default timezone so logs show local time instead of UTC
# Personal note: changed to Asia/Shanghai for my local timezone
ENV TZ=Asia/Shanghai

# Set Python to unbuffered mode so logs appear immediately in docker logs output
ENV PYTHONUNBUFFERED=1

# Personal note: added PYTHONDONTWRITEBYTECODE to avoid cluttering the container
# with .pyc files since this is just for local dev/learning
ENV PYTHONDONTWRITEBYTECODE=1

# Personal note: set NODE_ENV to development explicitly so any libraries that
# check this variable behave consistently in my local dev environment
ENV NODE_ENV=development

# Personal note: set UV_NO_CACHE=1 to avoid uv caching packages inside the
# container, keeping the image size smaller for local dev use
ENV UV_NO_CACHE=1

# Personal note: set UV_COMPILE_BYTECODE=0 to skip compiling .pyc files during
# uv sync, consistent with PYTHONDONTWRITEBYTECODE above
ENV UV_COMPILE_BYTECODE=0

# Personal note: set FORCE_COLOR=1 so that tools like pytest and npm scripts
# output colored text even inside the container, making logs easier to read
ENV FORCE_COLOR=1

# Personal note: set PYTHONFAULTHANDLER=1 so that if the backend crashes with a
# segfault or similar low-level error, Python will print a full traceback to
# stderr automatically — very helpful for debugging in local dev
ENV PYTHONFAULTHANDLER=1

# Personal note: set PYTHONASYNCIODEBUG=1 to enable asyncio debug mode, which
# logs warnings for slow callbacks and unawaited coroutines — useful for
# catching async bugs early during local development
ENV PYTHONASYNCIODEBUG=1

# Personal note: set PYTHONWARNINGS to show all warnings (including
# DeprecationWarning) during local dev so I can catch issues early
ENV PYTHONWARNINGS=all

# 同时启动前后端（开发模式）
CMD ["npm", "run", "dev"]
