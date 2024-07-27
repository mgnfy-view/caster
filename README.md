<!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]


<!-- PROJECT LOGO -->
<br />
<div align="center">
  <!-- <a href="https://github.com/mgnfy-view/caster">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a> -->

  <h3 align="center">Caster</h3>

  <p align="center">
    Caster is a merkle tree based efficient, general purpose voting protocol which also supports fractional vote delegation
    <br />
    <a href="https://github.com/mgnfy-view/caster"><strong>Explore the docs »</strong></a>
    <br />
    <a href="https://github.com/mgnfy-view/caster/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    ·
    <a href="https://github.com/mgnfy-view/caster/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>


<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About The Project

Caster is a general purpose, on-chain, merkle tree based voting protocol which also supports fractional vote delegation. Users can create voting campaigns in a permissionless manner by supplying a merkle root and the campaign params, and paying a fee of `0.001 ether`. Voting campaigns can be single option (rhetorical questions), or multiple option voting campaigns (select from an array of options). Whitelisted users eligible to vote in a campaign can mint themselves a unique voting id (Caster Nft) by verifying themselves as a part of the merkle tree. This Nft provides the voters with the voting power assigned by the campaign creator.

Voters can delegate their votes to a single user or multiple users (fractional vote delegation). By default, votes are delegated to the voter itself and once the voter delegates to another user, they cannot be recovered.

Campaigns run for a finite duration (less than 365 days, which is the max duration). At the end ofeach campaign, the result can be obtained using `CasterCampaign::getResultSingleOption()` or `CasterCampaign::getResultMultipleOption()` depending on the campaign type.

### Built With

- ![Foundry](https://img.shields.io/badge/-FOUNDRY-%23323330.svg?style=for-the-badge)
- ![Solidity](https://img.shields.io/badge/Solidity-%23363636.svg?style=for-the-badge&logo=solidity&logoColor=white)
- ![NodeJS](https://img.shields.io/badge/node.js-6DA55F?style=for-the-badge&logo=node.js&logoColor=white)
- ![PNPM](https://img.shields.io/badge/pnpm-%234a4a4a.svg?style=for-the-badge&logo=pnpm&logoColor=f69220)


<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

Make sure you have git, node.js, and pnpm installed and configured on your system.

### Installation

Clone the repo,

```shell
git clone https://github.com/mgnfy-view/caster.git
```

cd into the repo, and install the necessary dependencies

```shell
cd caster
forge test
pnpm intall
```

That's it, you are good to go now!


<!-- ROADMAP -->
## Roadmap

- [x] Smart contract development
- [x] Unit tests
- [x] Write Docs
- [x] Write a good README.md

See the [open issues](https://github.com/mgnfy-view/caster/issues) for a full list of proposed features (and known issues).


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.


<!-- CONTACT -->
## Reach Out

Here's a gateway to all my socials, don't forget to hit me up!

[![Linktree](https://img.shields.io/badge/linktree-1de9b6?style=for-the-badge&logo=linktree&logoColor=white)][linktree-url]


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/mgnfy-view/caster.svg?style=for-the-badge
[contributors-url]: https://github.com/mgnfy-view/caster/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/mgnfy-view/caster.svg?style=for-the-badge
[forks-url]: https://github.com/mgnfy-view/caster/network/members
[stars-shield]: https://img.shields.io/github/stars/mgnfy-view/caster.svg?style=for-the-badge
[stars-url]: https://github.com/mgnfy-view/caster/stargazers
[issues-shield]: https://img.shields.io/github/issues/mgnfy-view/caster.svg?style=for-the-badge
[issues-url]: https://github.com/mgnfy-view/caster/issues
[license-shield]: https://img.shields.io/github/license/mgnfy-view/caster.svg?style=for-the-badge
[license-url]: https://github.com/mgnfy-view/caster/blob/master/LICENSE.txt
[linktree-url]: https://linktr.ee/mgnfy.view