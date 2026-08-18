# Which CSI is the best for my cluster

- Status: Accepted
- Date: 2026-08-18

## Context and Problem Statement

Choosing a CSI for the cluster has implications on availability of the cluster and integrity of the data stored on it. Longhorn V1 is soon to be deprecated but is the easiest option for setting up disk replication for a multi-node cluster.

Longhorn V2 seems to require enterprise disks for the best IOPS and fault tolerance. Same goes for rook-ceph. They both require dedicated disk partitions, which I don't have in my current nodes since they only have 1 consumer-grade NVMe disk per node.

Which CSI should be picked?

Relates to: https://codeberg.org/paccao/homelab/issues/13

## Decision Drivers

- I want a simple setup.
- I want decent, but not the highest availability.
- I want low maintenance, automate as much as possible.

## Considered Options

1. Longhorn with the V1 data plane.
1. Longhorn with the V2 data plane.
1. Rook-ceph inside of the cluster.
1. Upgrade nodes to 3 disks per node, preferably with enterprise-grade disks. Rook-ceph on dedicated disks, etcd on their own dedicated disks.

## Decision Outcome

Chosen option: 1, Longhorn V1 single-disk-nodes with both etcd and storage on it. It fits my budget the best right now and the mitigations specified in the Pros and Cons outweighs the other options.

I will revisit this decision in the future as I would likely upgrade to option 4 when it fits my budget. There are also other options that I didn't consider here, such as running an external Ceph cluster on dedicated nodes but that is not an option right now so I didn't even consider it.

## Pros and Cons of the Options

### [option 1]

Longhorn V1 on the same disk partition as the ETCd cluster.

- Good, because simple to set up.
- Good, because I know how to configure it already.
- Good, because I don't need to upgrade my hardware and spend €€€.
- Good, because from what I read, V1 doesn't wear and tear on the hardware as much as V2 and rook-ceph.
- Bad, because if a harddrive fails, I might lose the entire cluster - I might have to reconfigure the nodes and TalOS. Somewhat mitigated since I have implemented GitOps and I can recover the cluster applications with ease.
- Bad, because there is risk of disk failure and data loss - I purchased consumer-grade NVMe's and all of them come from the same batch from the factory AFAIK. This can be mitigated with an automated backup and restore solution.

### [option 2]

Longhorn V2 on a single-disk k8s node, where ETCd also lives.

- Good, because longhorn V2 seems to have better replication and data integrity from what I have read, than V1.
- Bad, because rook-ceph seems to be the more popular CSI among the homelab community, there is less support to be had generally.
- Bad, because running longhorn V2 wear and tears on consumer-grade hardware very fast, I might have to replace the disks in one year.
- Impossible to do, it requires a dedicated hard drive, which I currently don't have. My raspberry pi 5 nodes only support 1 hard drive at the moment so I would need to upgrade them. Multi-drive setups on rpi5 isn't widely supported yet so the setup is complicated also.

### [option 3]

Rook-ceph on a single-disk k8s node, where ETCd also lives.

- Good, because rook-ceph seems to be more battle-tested than Longhorn V1 and V2.
- Good, because rook-ceph is more popular in the homelab community, there is more support to be had if needed.
- Good, because I can copy another homelabbers config and get set up really quickly.
- Bad, because if the disk fails I might lose both cluster state and storage at once. I would have 3 nodes with replication between them but its not 100% guaranteed that I will keep my data.
- Bad, because the wear and tear on the hardware is really bad if I run both ETCd and rook-ceph on the same disk.
- Bad, because it creates contention between etcd's latency-sensitive writes and Rook's heavy I/O. Basically everyone in the homelab community refrains from running rook-ceph and etcd on the same disk, especially on consumer grade hardware which doesnt have great IOPS.
- Bad, because enterprise hardware is stupid expensive right now.


### [option 4]

Upgrade hardware for my nodes, run etcd and rook-ceph on separate dedicated disks with higher fault tolerance per node.

- This is obviously the best solution, so I didn't dig into it more than that.
- Bad, because €€€^infinity

## Things to follow up on based on this decision outcome

- Configure Longhorn V1. See [Issue 13](https://codeberg.org/paccao/homelab/issues/13)
- Set up Volsync for automated backup and restores using a GitOps flow. Relates to [Issue 14](https://codeberg.org/paccao/homelab/issues/14)
- Set up off-shore backups of my storage. Relates to [Issue 16](https://codeberg.org/paccao/homelab/issues/16)
