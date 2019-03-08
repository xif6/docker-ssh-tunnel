# Docker SSH Tunnel

This Docker creates a multiple SSH tunnel over a server. It is very useful when your container needs to access to an external protected resource.

## Usage

### Configuration

- `$REMOTE_HOST` the remote host you want to set up a local tunnel for
- `$PORTS` list of the ports you want to forward, each forward separated by commas. Format for one forward `local_port:remote_port`, if use the same port `port`
- `$USERNAME` the username for your ssh key (default: `root`)
- `$BIND_ADDRESS` the address you want to bind the tunnel to. (default: `127.0.0.1`)

### Running the tunnel

- First you should create a config file in your local directory. For simplicity you can create this file in `~/.ssh` in your local machine.

- Inside `~/.ssh/config` put these lines:
    ```
    Host tunneled.corporate.internal.tld # You can use any name, MUST match REMOTE_HOST
        HostName ssh-tunnel.corporate.tld # Tunnel 
        IdentityFile ~/.ssh/id_rsa # Private key location
        User username # Username to connect to SSH service
        ForwardAgent yes
        TCPKeepAlive yes
        ConnectTimeout 5
        ServerAliveCountMax 10
        ServerAliveInterval 180
    ```
- Don't forget to put your private key (`id_rsa`) to `~/.ssh` folder.

- #### With docker
    ```
    $ docker run --rm
        -p "8080:8080" \
        -v ~/.ssh:/root/ssh:ro \
        -e REMOTE_HOST=tunneled.corporate.internal.tld \
        -e PORT=3306,8080:80 \
        -e USERNAME=username \
        -e BIND_ADDRESS=localhost \
        xif6/docker-ssh-tunnel
    ```

- #### With docker-compose
    Now in `docker-compose.yml` you can define the tunnel as follows:

    ```
    version: '2'
    services:
      ssh-tunnel:
        image: xif6/docker-ssh-tunnel
        volumes:
          - ~/.ssh:/root/ssh:ro
        environment:
          REMOTE_HOST: tunneled.corporate.internal.tld
          PORTS: 3306,8080:80
          USERNAME: username
          BIND_ADDRESS: localhost
        ports:
          - "8080:8080"
    ```
Run `docker-compose up -d`

After you start up docker containers, any container in the same network will be able to access to tunneled mysql instance using ```tcp://mysql:3306``` ```http://127.0.0.1:8080```.

