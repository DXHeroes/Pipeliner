# Contributing to Pipeliner

It seems like you want to participate on our Pipeliner - that's great! We welcome contributions to our [open source project on GitHub](https://github.com/DXHeroes/Pipeliner).

## Introduction

We are glad that you are interested in Pipeliner in the way of contributing. We value the pro-community developers as you are.

## Help the community

1) Report an Error or a Bug 🐛
2) Request a Feature 🆕
3) Contribute to the Code 👨‍💻👩‍💻
4) Contribute to the Documentation 📝
5) Provide Support on Issues ℹ️

## Need help?

If you have any question about this project (for example, how to use it) or if you just need some clarification about anything, please open an Issue at [Issues](https://github.com/DXHeroes/Pipeliner/issues).

## Contributing

Follow these steps:

1. **Fork & Clone** the repository  
2. **Setup** the Pipeliner
   - install Big Sur ([MacOS Big Sur](https://beta.apple.com/sp/betaprogram/enroll))
   - install XCode 12 ([XCode12](https://developer.apple.com/xcode/))
   - To configure for local development, go to Pipeliner Project `->` Pipeliner, PipelinerWidgetExtension Targets `->` Signing & Capabilities: 
      - change Team to your Personal team
      - change Signing Certificate to "Sign to Run Locally"
3. **Installation**
App uses [PromiseKit](https://github.com/mxcl/PromiseKit) and [AwaitKit](https://github.com/yannickl/AwaitKit). These dependencies should be resolved by XCode automatically.
4. **Build** the pipeliner main app and pipelinerWidget by cliking `build` in `product` menu or by ```command + B``` shortcut 
5. **Start** the pipeliner main app by clicking "play" button.
  - If you are running Xcode Version 12.2 beta 3 and the program is crashing with a `SIGCONT` message, try one of the alternatives listed in this [Apple Developer thread](https://developer.apple.com/forums/thread/663823).
6. **Start** the pipeliner widget by selecting `PipelinerWidgetExtension` from targed drop down and clicking "play" button. Widget should start in WidgetSimulator
7. **Commit** changes to your own branch by convention. See https://www.conventionalcommits.org/en/v1.0.0/
8. **Push** your work back up to your fork  
9. Submit a **Pull Request** so that we can review your changes

**NOTE: Be sure to merge the latest from "upstream" before making a pull request.**

## Contribute Code

### Practices

Check your repository for using the correct tooling which improves product development.


## Copyright and Licensing

The Pipeliner open source project is licensed under the [MIT License](LICENSE).

