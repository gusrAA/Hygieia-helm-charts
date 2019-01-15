# Hygieia Chart Example Deployment

This branch is to showcase an example deployment that we use in our environment.

## Usage

First you need to add the hygieia repository.
```
$ helm repo add hygieia https://gusraa.github.io/Hygieia-helm-charts/
```

Update the values.yaml file to match the configuration in your environment. If adding passwords to it make sure not to commit it to version control.

Once you've got your configurations set you can use the following command to deploy and upgrade your deployment:
```
$ helm upgrade --install \
               hygieia \
               hygieia/hygieia \
               -f values.yaml
```

I like to store my configuration in Git so I make sure not to store passwords. You can override the passwords during the installation like this:
```
$ helm upgrade --install \
               hygieia \
               hygieia/hygieia \
               -f values.yaml \
               --set env.SPRING_DATA_MONGODB_PASSWORD=...
```

Good to use with something like Jenkins + a password vault
