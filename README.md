# MiroFish

<div align="center">

<img src="./static/image/MiroFish_logo_compressed.jpeg" alt="MiroFish Logo" width="75%"/>

<a href="https://trendshift.io/repositories/16144" target="_blank"><img src="https://trendshift.io/api/badge/repositories/16144" alt="666ghj%2FMiroFish | Trendshift" style="width: 250px; height: 55px;" width="250" height="55"/></a>

简洁通用的群体智能引擎，预测万物
</br>
<em>A Simple and Universal Swarm Intelligence Engine, Predicting Anything</em>

<a href="https://www.shanda.com/" target="_blank"><img src="./static/image/shanda_logo.png" alt="666ghj%2MiroFish | Shanda" height="40"/></a>

[![GitHub Stars](https://img.shields.io/github/stars/666ghj/MiroFish?style=flat-square&color=DAA520)](https://github.com/666ghj/MiroFish/stargazers)
[![GitHub Watchers](https://img.shields.io/github/watchers/666ghj/MiroFish?style=flat-square)](https://github.com/666ghj/MiroFish/watchers)
[![GitHub Forks](https://img.shields.io/github/forks/666ghj/MiroFish?style=flat-square)](https://github.com/666ghj/MiroFish/network)
[![Docker](https://img.shields.io/badge/Docker-Build-2496ED?style=flat-square&logo=docker&logoColor=white)](https://hub.docker.com/)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/666ghj/MiroFish)

[![Discord](https://img.shields.io/badge/Discord-Join-5865F2?style=flat-square&logo=discord&logoColor=white)](http://discord.gg/ePf5aPaHnA)
[![X](https://img.shields.io/badge/X-Follow-000000?style=flat-square&logo=x&logoColor=white)](https://x.com/mirofish_ai)
[![Instagram](https://img.shields.io/badge/Instagram-Follow-E4405F?style=flat-square&logo=instagram&logoColor=white)](https://www.instagram.com/mirofish_ai/)

[English](./README.md) | [中文文档](./README-ZH.md)

</div>

> **Personal fork note:** I'm using this project to explore multi-agent simulation for financial market prediction. The upstream repo is at [666ghj/MiroFish](https://github.com/666ghj/MiroFish).
>
> **My focus areas:**
> - Testing agent behavior with stock market news as seed data
> - Experimenting with larger agent populations (1000+) to observe emergent trends
> - Tracking how sentiment signals propagate through the simulated agent network
>
> **Personal notes / findings so far:**
> - With 1000+ agents, simulation runs can get slow — I bumped the default agent count in my config to 200 for quicker iteration during development
> - Financial news seeds seem to produce more polarized sentiment distributions than narrative/story seeds; worth investigating further
> - Noticed that running multiple simulations back-to-back with the same seed doesn't always yield identical results — seems like there may be non-deterministic behavior in agent initialization; need to look into whether a random seed option exists
> - **Update:** Found that setting `random_seed` in the config does stabilize results across runs — confirmed reproducible output with `random_seed: 42`. Documenting here so I don't forget.
> - **Update 2:** Tried bumping `sentiment_decay_rate` from the default `0.05` to `0.10` — decay happens noticeably faster, which seems more realistic for financial news (sentiment around earnings reports fades quickly). Going to keep `0.08` as my working default as a middle ground.
> - **Update 3:** Lowering `interaction_radius` from `0.3` to `0.2` produces more distinct opinion clusters — useful when I want to see how isolated "bubbles" form. Default `0.3` is fine for general use though.
