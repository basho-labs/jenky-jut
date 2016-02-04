# Jenky JuT (jenky-jut)

## Purpose
Build a standalone Jenkins vagrant to define Jenkins jobs, ensuring all build
machine dependencies are known and can be installed via a repeatable process.

## Quickstart
1. Edit env.sh, specifying the TARGET_VM and TARGET_VM_VARIANT.
1. Ensure ~/.ssh/id_rsa is present and can be used to clone repos via git.
 * SSH_KEY may be used to specify an alternative private key file.
 * NOTE: the passphrase will be stripped to ease development. Build boxes
   should be both secure and transient, so not a source to steal keys.
1. Ensure AWS_ACCESS_KEY and AWS_SECRET_KEY are set in the environment.
 * The AWS credentials are used to store artifacts on S3, but may be used to
   procure EC2 instances if/when vagrant-aws is used to procure hardware.
1. Setup the environment via `. env.sh`
1. Spin up the vagrant via `vagrant up`
1. Install dependent Jenkins plugins, ie github, via
   `./install_jenkins_plugins.sh`
1. Create all Jenkins jobs defined in jenkins/jobs/ via `create_jenkins_jobs.sh`
1. Open Jenkins via (OSX example) 'open http://127.0.0.1:18080'.
1. Within the Jenkins UI, test by building a job.

## Defining Jobs
### Manually
1. Setup a base Jenkins vagrant.
1. configure a job in Jenkins.
1. Extract the job definition via the Jenkins api
 * `curl http://localhost:18080/job/$job_id/config.xml`

### By Example
1. Copy a jenkins job config from jenkins/jobs/, setting the destination
filename to the job_id of the new job.
1. Edit the respective fields, ie
 * git url
 * bit BranchSpec
 * Shell

## Rules of the Road
First, there are no rules, just guidance for how to make it.

 * Make each unit re-entrant
  * Ensure external dependencies are satisfied at the unit setup.
  * Test internal intermediate bits for existence before performing action t
    bring them into existence.
 * Fail fast
  * Test outputs as close to when they are produced and bail out if they fail to
    meet downstream requirements.
 * Reduce cycle time
  * Cache outputs
   * Roll a tarball and storing the artifact in S3
   * Name/tag artifacts in a manner that includes matrix variant details, such
     as operating system flavor ($DISTRIB_ID) and version ($DISTRIB_RELEASE) as
     well as such variant details for the product.
  * Cache inputs
   * Cache OS packages via vagrant-cachier.
   * Use the /downloads directory on the vagrant to store downloaded content for
     reuse across vagrants.
  * Draw modular lines
   * Use artifact boundaries for guidance.

## Design
### Self-Mastered
As the purpose of the Jenkins vagrant build utility is to develop a build, not
host a build service, the vagrant serves as both Jenkins Master and Slave.

### Tooling
This Jenkins vagrant build utility utilizes minimal tooling for the following
reasons:

 * Minimal bootstrap of the Jenkins vagrant builder
 * Built on extremely highly tested units
 * Open, locally available source for rapid debugging
 * Ubiquitous tooling, so success steps and errata are easily shared
 * Cross-platform differences are clearly present and visible via diff
 * Low learning curve, everyone must know sh
 * Ability to develop/test locally

Alternatives for provisioning considered include bare metal, native cloud
scripting, and language-specific libraries such as boto. Each of these
solutions is superior for their intended use, but for the purposes of this
use are inferior at varying levels respective to the reasons for selecting
minimal tooling, but more so to support a local develop/test loop.

Alternatives for setup considered include brooklyn, nix, puppet, chef, and
ansible. Each of these solutions is superior for their intended use, but for
the purposes of this use are inferior at varying levels respective to the
reasons for selecting minimal tooling.

## Supported Operating Systems

| Flavor | Nickname | M.m   |
|--------|----------|-------|
| CentOS | 6        | 6.7   |
| CentOS | 7        | 7.1   |
| Ubuntu | Precise  | 12.04 |
| Ubuntu | Trusty   | 14.04 |

## Forking Branches
This is a jenky setup which needs to be better designed with regard to
contribution of installable modules.

As it stands, the $os/install_$module.sh scripts should be re-usable across
build-specific Jenkins vagrant setups. As modules are proven across supported
operating systems

The $os/install.sh scripts are expected to differ per project, so would need to
be excluded from contribution. Complicating things, the $os/install.sh scripts
contain code.

So until the module listing is factored out into a file that can be
automatically ignored (.gitignore), care should be taken to separate commits
to $os/install.sh that are for actual code improvement from commits that
change the module listing.

The jenkins/ directory contains generally necessary components for an
opinionated setup, such as plugins.ls, so this directory is not ignored.

The jenkins/jobs/ directory contains specific job definitions, so should be
ignored.

## Testing
The outermost proof of a build setup is to obtain a valid built product from a
build machine built from a base operating system image. This level of assurance
is provided by building the product artifact for all supported operating
systems.

Automation of the generation of such a matrix is not yet provided and requires
spinning up of a vagrant per operating system variant, acting as Jenkins build
slaves. Breaking out a Jenkins build master would also be required.

Automated testing of a module to install what it intends to install is not
generalizable. Assertions via standard shell scripting are also well known, so
no efforts were made to provide this level of test support.

Automated testing of modularity is also not provided. To automate testing of a
module to be fully capable of being installed can be provided with minimal
effort by changing the module order within $os/install.sh . Such a feature
should be included in separating the module listing from the $os/install.sh
code.

## How to Contribute

* Fork the project on Github. If you have already forked, use `git pull --rebase`
to reapply your changes on top of the mainline. Example:

```shell
git checkout master
git pull --rebase basho master
```

* Create a topic branch. If you've already created a topic branch, rebase it on
top of changes from the mainline "master" branch. Examples:
 * New branch:

```shell
git checkout -b topic
```

 * Existing branch:

```shell
git rebase master
```

 * Write an RSpec example or set of examples that demonstrate the necessity and
   validity of your changes. **Patches without specs will most often be ignored.
   Just do it, you'll thank me later. Documenation patches need no specs, of course.

 * Make your feature addition or bug fix. Make your specs and stories pass (green).

 * Run the suite using multiruby or rvm or rbenv to ensure cross-version
   compatibility.

 * Cleanup any trailing whitespace in your code and generally follow the coding
   style of existing code.

 * Send a pull request to the upstream repositoty.

## License & Copyright
Copyright ©2015-2016 James Gorlick and Basho Technologies, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
