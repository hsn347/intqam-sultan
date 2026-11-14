gSvrConfig, _ENV = nil, nil
_ENV = nil
;(nil).test = "10.0.0.211"
;(nil).review_server = "ros.review.menaapp.net"
gSvrConfig.ipCfg, (nil).release_open = nil, "kohlogin.menaapp.net"
gSvrConfig.loginPort = 10000
gSvrConfig.closeIpv6 = true
gSvrConfig.isReview = true
if gSvrConfig.isReview then
	gSvrConfig.closeIpv6 = false
	gSvrConfig.ip = gSvrConfig.ipCfg.review_server
else
	gSvrConfig.ip = gSvrConfig.ipCfg.release_open
end
local currentCarrier = SoraDGetCarrier()
local netType = network.getInternetConnectionStatus()
if netType == gCCNetworkStatusReachableViaWWAN then
	for k, v in pairs(gCarrierOnlySupportIpv6) do
		if currentCarrier == v then
			gSvrConfig.closeIpv6 = false
			break
		end
	end
end
gSvrConfig.facebookHomepage = "https://www.facebook.com/slateen"
gSvrConfig.complainAddr = "https://complain.menaapp.net"
if userSDKManager.isBeta() then
	gSvrConfig.complainAddr = "https://complaintest.menaapp.net/"
	_UPVALUE2_ = pairs(gCarrierOnlySupportIpv6)
	gSvrConfig.updateAddr, pairs(gCarrierOnlySupportIpv6)[1] = pairs(gCarrierOnlySupportIpv6)
	gSvrConfig.updateAddr, pairs(gCarrierOnlySupportIpv6)[2] = pairs(gCarrierOnlySupportIpv6)
	_ENV = pairs(gCarrierOnlySupportIpv6)
	pairs(gCarrierOnlySupportIpv6).url = "http://kohupdate.menaapp.net/%s/%s/%s/"
	gSvrConfig.updateDownAddr, pairs(gCarrierOnlySupportIpv6).burl = pairs(gCarrierOnlySupportIpv6)
else
	_UPVALUE2_ = pairs(gCarrierOnlySupportIpv6)
	gSvrConfig.updateAddr, pairs(gCarrierOnlySupportIpv6)[1] = pairs(gCarrierOnlySupportIpv6)
	gSvrConfig.updateAddr, pairs(gCarrierOnlySupportIpv6)[2] = pairs(gCarrierOnlySupportIpv6)
	_ENV = pairs(gCarrierOnlySupportIpv6)
	pairs(gCarrierOnlySupportIpv6).url = "http://kohupdate.menaapp.net/%s/%s/%s/"
	gSvrConfig.updateDownAddr, pairs(gCarrierOnlySupportIpv6).burl = pairs(gCarrierOnlySupportIpv6)
end
gSvrConfig.insideNewArea = "https://p.onemt.co/"
_ENV = pairs(gCarrierOnlySupportIpv6)
pairs(gCarrierOnlySupportIpv6).beta = "https://kohh5beta.onemt.co/%s?inviteCode=%s&name=%s&source=%s&lang=%s&channel=%s%s"
gSvrConfig.shareUrlConfig, pairs(gCarrierOnlySupportIpv6).publish = pairs(gCarrierOnlySupportIpv6)
_ENV = pairs(gCarrierOnlySupportIpv6)
pairs(gCarrierOnlySupportIpv6).service = "https://www.onemt.com/abroadgame/outer/terms/"
gSvrConfig.linkUrlConfig, pairs(gCarrierOnlySupportIpv6).policy = pairs(gCarrierOnlySupportIpv6)
return gSvrConfig
