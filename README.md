<!-- ghmig:moved -->
> **This repository has moved to [https://git.navicore.tech/navicore/concourse-docker](https://git.navicore.tech/navicore/concourse-docker).**
>
> The GitHub copy is archived and no longer maintained.

Docker Image for Concourse CI
----

for dev/debugging concourse on kubernetes in aws and azure.

each image build auto-generates new keys.  each container in each cluster needs
launch from the same image.

todo: inject keys at runtime, not build time.