VERSION=0.0.2
IMAGE=ubuntu-dotfiles:$(VERSION)
FILE_URL=dot.yukin01.dev

.PHONY: build local test

build:
	docker build . -t $(IMAGE)

local:
	docker run -it --rm \
		-v $(HOME)/dotfiles:/home/ubuntu/tmp/dotfiles:ro \
		-v $(HOME)/.ssh/id_ed25519:/home/ubuntu/id_ed25519_tmp:ro \
		-e GIT_SSH_COMMAND="ssh -i /home/ubuntu/id_ed25519_tmp" \
		$(IMAGE)

test:
	docker run -it --rm $(IMAGE) \
		/bin/bash -c "$$(curl -fsSL $(FILE_URL))"
