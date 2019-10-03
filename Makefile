BROWSER_REMOTE=(chromium-browser \
	--headless \
	--disable-gpu \
	--remote-debugging-address=127.0.0.1 \
	--remote-debugging-port=9222 \
	)

GENERATE_RESUME=(go run resume.go -resume=$@.yaml -output=output/$@)
CONVERT_PDF_TO_PNG=(convert -density 500 -define profile:skip=ICC output/$@.pdf[0] output/$@.png)

.PHONY: start stop example resume

start:
	{ ${BROWSER_REMOTE} & echo $$! > remote.PID; }
	sleep 5

stop:
	kill `cat remote.PID` && rm remote.PID

example: start
	$(GENERATE_RESUME)
	$(CONVERT_PDF_TO_PNG)
	$(MAKE) stop

resume: start
	$(GENERATE_RESUME)
	$(CONVERT_PDF_TO_PNG)
	$(MAKE) stop
