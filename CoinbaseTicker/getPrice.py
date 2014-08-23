import urllib2, json

def getBuyPrice():
	url = 'https://coinbase.com/api/v1/prices/buy'
	request = urllib2.Request(url)
	request.add_header('Accept', 'application/json')
	res = urllib2.urlopen(request)
	data = json.load(res)
	return data["subtotal"]["amount"]

def getSellPrice():
	url = 'https://coinbase.com/api/v1/prices/sell'
	request = urllib2.Request(url)
	request.add_header('Accept', 'application/json')
	res = urllib2.urlopen(request)
	data = json.load(res)
	return data["subtotal"]["amount"]

def update():
    buyPrice = getBuyPrice()
    #sellPrice = getSellPrice()
    #now = datetime.now().strftime('%H:%M:%S')
    #os.system('clear')
    #print 'Updated ' + now
    print buyPrice
    #print 'Sell: ' + sellPrice