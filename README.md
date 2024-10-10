# Sonatype PyTorch PyPI Improved Mirror

<!-- Badges Section -->
[![shield_gh-workflow-test]][link_gh-workflow-test]
[![shield_license]][license_file]
<!-- Add other badges or shields as appropriate -->

---

This project provides a PyTorch Python index mirror that adds necessary strict PEP 503 format requirements permitting to use it with [Nexus Repository](https://help.sonatype.com/en/pypi-repositories.html#download--search--and-install-packages-using-pip).

- [Sonatype PyTorch PyPI Improved Mirror](#sonatype-pytorch-pypi-improved-mirror)
  - [Usage](#usage)
    - [Installation](#installation)
    - [Access With `pip`](#access-with-pip)
  - [Development](#development)
  - [The Fine Print](#the-fine-print)

## Usage

### Installation

As a [Nexus Repository](https://help.sonatype.com/en/sonatype-nexus-repository.html) admin, configure a [new PyPI proxy](https://help.sonatype.com/en/pypi-repositories.html#proxying-pypi-repositories) repository:
- define name: `pypi-pytorch` for example
- define URL for remote storage: `https://sonatype-nexus-community.github.io/pytorch-pypi/whl/`

You can also create compute platform specific proxies if necessary, like `pypi-pytorch-cu124` pointing to `https://sonatype-nexus-community.github.io/pytorch-pypi/whl/cu124/`

These PyPI proxies can also be added to your `pypi-all` group repository if you created one.

### Access With `pip`

Newly created PyPI proxies can now be used with `pip` using provided `--index-url`, like:

```
pip3 install pytorch+cu124 --index-url http://localhost:8081/repository/pypi-pytorch/simple
```
or
```
pip3 install pytorch --index-url http://localhost:8081/repository/pypi-pytorch-cu124/simple
```

## Development

See [CONTRIBUTING.md](./CONTRIBUTING.md) for details.

## The Fine Print

Remember:

This project is part of the [Sonatype Nexus Community](https://github.com/sonatype-nexus-community) organization, which is not officially supported by Sonatype. Please review the latest pull requests, issues, and commits to understand this project's readiness for contribution and use.

* File suggestions and requests on this repo through GitHub Issues, so that the community can pitch in
* Use or contribute to this project according to your organization's policies and your own risk tolerance
* Don't file Sonatype support tickets related to this project— it won't reach the right people that way

Last but not least of all - have fun!

<!-- Links Section -->
[shield_gh-workflow-test]: https://img.shields.io/github/actions/workflow/status/sonatype-nexus-community/pytorch-pypi/update.yml?branch=main&logo=GitHub&logoColor=white "build"
[shield_license]: https://img.shields.io/github/license/sonatype-nexus-community/pytorch-pypi?logo=open%20source%20initiative&logoColor=white "license"

[link_gh-workflow-test]: https://github.com/sonatype-nexus-community/pytorch-pypi/actions/workflows/update.yml?query=branch%3Amain
[license_file]: https://github.com/sonatype-nexus-community/pytorch-pypi/blob/main/LICENSE
