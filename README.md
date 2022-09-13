# pypi-docker

PyPi Docker is an application to initialized project with docker and docker-compose before create PyPi package

## Customize pypi-docker

### Requirements
- [Docker](https://docs.docker.com/get-docker/): we use _Docker_ to develop pypi-docker. This is a strict requirement to use this project.
- [Docker Compose](https://docs.docker.com/compose/install/): we use _Docker Compose_ to simplify the orchestration.

Download this repository and unzip it on your computer.

Or clone the repository directly on your computer:
``` bash
$ git clone git@github.com:acuffel/pypi-docker.git
```

### Install and run a development environment

Once you have customized your environment variables in `.env`, you can build and start a development environment with the following command:

``` bash
$ make dev
```

Into the container update and install requirements
```bash
$ make venv
$ make requirements
$ make install
```

Customize the project in the repository `src/pypi-docker`

Create and run tests
```bash
$ make tests
```

Update documentation in `README.md` and `CHANGELOG.md` and version in `pyproject.toml` and `.env` and build the project

```bash
$ build
```

> **Notes for users:**  
> You can try the package from your local file system with pip install -e /$PATH

Leave the container and commit your release into github
```bash
$ git commit -am 'New commit'
$ git push 
```

Update the version in test-PyPI in [github-actions](https://github.com/acuffel/pypi-docker/actions/) with the workflow `Test PyPi`.

When all is ready, run the workflow `Pypi` to update the official new version
