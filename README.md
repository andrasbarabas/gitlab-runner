# GitLab Runner

## Table of Contents

- [Prerequisities](#prerequisites)
- [Installation](#installation)
  - [Creating project runner](#creating-project-runner)
  - [Setting up the self-hosted runner](#setting-up-the-self-hosted-runner)
  - [Configuring the self-hosted GitLab runner](#configuring-the-self-hosted-gitlab-runner)

## Prerequisites

- [Ansible](https://www.ansible.com/)

## Installation

### Creating project runner

1. Open [GitLab.com](https://gitlab.com) then navigate to your [project's CI/CD settings](https://gitlab.com/<your-group>/<your-project>/-/settings/ci_cd) page.
2. Expand *Runners* section.
3. First, turn off instance runners by unchecking *Enable instance runners for this project* checkbox on the right side of the page.
4. Now, on the left side, look for *New project runner* button and click on it.
5. On the next page, fill the necessary configurations for your runner instance. For the sake of testing, leave everything blank except for *Run untagged jobs*.
6. On the next page, below **Step 1** section, copy/save your generated **runner authentication token** (`glrt-xxxxxxxxxxxxxxxxxxxx`) as you will need it in a further process of the installation.
7. You can either leave this page open to ensure GitLab runner registration process was successful (you will see a successful message on the bottom of the page once Ansible playbook scripts succeed) or just close it now.

### Setting up the self-hosted runner

If you haven't done so, [create a project runner](#creating-project-runner) on GitLab.com.

Next, within the project root folder, run the following command:

```
cp /.iac/inventories/inventory.example ./iac/inventories/inventory.ini
```

Adjust the newly created `.ini` file (below `./iac/inventories/`) with your server's access info.

Once ready, (navigate to the project root, then) type `make build`. This triggers the Ansible deployment playbook and your GitLab Runner instance will be ready soon.

You can also trigger individual Ansible playbooks separately as they are specified within the Makefile.

At a certain point of the deployment, you will be prompted to pass your **GitLab Runner authentication token**. Paste the token created in [create a Project runner](#creating-project-or-group-runner) section.

For now, you are not able to pass extra parameters to the runner [configuration](#configuring-the-self-hosted-gitlab-runner) via this deployment tool (for example `executor`, `image`, etc.). Please, adjust `config.toml` manually to meet your needs on your self-hosted runner server (`/etc/gitlab-runner/config.toml`).

Once the installation completes, open your project's CI/CD settings page again and
expand **Runners** section. Under **Assigned project runners** section on the left side, you should see your recently created runner as connected to the remote server with a green dot signaling the active status.

From now on, running CI/CD pipelines within your project will be redirected to your self-hosted runner without CI/CD compute minutes limit.

### Configuring the self-hosted GitLab runner

*Coming soon*.
