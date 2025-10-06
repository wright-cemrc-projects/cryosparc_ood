Installation requires:

1) Running on a host that has CUDA installed under /usr/local/cuda
2) CryoSPARC installers setup in the a shared location to use to install in the user's home directory.
3) Hostname has to be valid, when used as all lower case. 
4) Academic license needs to be obtained

Install script has been modified to use a specific port range for users [40000-41000]. Open this range on your firewall with:

```
sudo firewall-cmd --zone=public --add-port=40000-41000/tcp --permanent
sudo firewall-cmd --reload
```

(Follow-up, can we limit the zone better than "public")
