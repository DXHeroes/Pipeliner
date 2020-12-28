
  <div align="center">
<h1> Pipeliner </h1>
</div>

[![Slack](https://img.shields.io/badge/slack-@DeveloperExperience-%234A154B.svg?logo=slack)](https://bit.ly/slack_developer_experience)
[![Pipeliner Roadmap](https://img.shields.io/badge/public%20roadmap-https%3A%2F%2Froadmap.dxheroes.io-%23108DE4)](https://roadmap.dxheroes.io)


## What is Pipeliner

Pipeliner is simple MacOS Big Sur widget app for checking pipeline status. Project consists of two apps: First, main application enables user to save configuration of repository. This configiration is saved on users Mac and is use to fetch pipelines data from GitLab/GitHub/BitBucket API.

<div style="float: left">
  <p align="center">
  <img src="https://github.com/DXHeroes/pipeliner/blob/master/docs/pipeliner.png" width="600" />
</p>
</div>

Second part of application is widget which shows status of (number of pipelines depends on widget selected size) last pipelines.
<div style="float: left">
  <p align="center">
    <img src="https://github.com/DXHeroes/pipeliner/blob/master/docs/widget.png" width="300" />
</p>
</div>
 It is created in Swift 5 and Swift UI using WidgetKit.

### What version control services are supported?

Language | Supported
------------ | -------------
GitLab | ✅
GitHub | ✅
BitBucket | 🚧

## Table of Contents

<!-- toc -->
* [Getting Started](#Getting-Started-)
  * [Dependencies](#Dependencies)
  * [Installation](#Installation)
* [Support](#support-%EF%B8%8F-%EF%B8%8F)
* [Issues](#issues)
* [Contributing](#contributing--)
  * [Roadmap](#Roadmap)
* [Licence](#license-)  
<!-- tocstop -->

## Getting Started 🏁

### Dependencies
- Apple ID
- Big Sur ([MacOS Big Sur](https://beta.apple.com/sp/betaprogram/enroll))

### Installation

1. **Fork & Clone** the repository
2. **Start** copy pipeliner.app in dist folder to Application folder and then configure & run 
3. **Add Widget** in the widget control menu

## Support 🦸‍♀️ 🦸‍♂️
You can find known issues [here](https://github.com/DXHeroes/Pipeliner/issues)
Didn't you find what you expected? Contact us via our public [Slack](https://bit.ly/slack_developer_experience)

## Issues
You can find issues [here](https://github.com/DXHeroes/Pipeliner/issues)

## Contributing 👩‍💻 👨‍💻
Feel free to contribute to our Pipeliner. Please follow the [Contribution Guide](CONTRIBUTING.md).

### Roadmap 

See our [public roadmap](https://roadmap.dxheroes.io).

## License 📝

The Pipeliner open source project is licensed under the [MIT](LICENSE).
