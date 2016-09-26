## Setup

- `./build-container.sh`
  - The mysql-server account is: `root:root`
- `./start-container.sh setup`
  - Enter mysql root password when prompted _TODO: this fails right now_
  - Next you will want to configure your mail system. Recommended:
    - "General type of mail configuration:" 4
    - "System mail name:" <your dns>
  - "Run proftpd:" 1
  - The script will then finish setup, and exit the container.  Once exited, the container will be committed as `froxlor:latest`.
- `./start-container.sh`
- Navigate to <http://localhost/froxlor>, follow install instructions.


## Todo

- Finish migrating backup stuff from <https://github.com/yofreke/docker-sentora>
- Fix mysql login error on container setup step