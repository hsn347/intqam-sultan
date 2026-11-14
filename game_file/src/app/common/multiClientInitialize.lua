multiClientInitialize, _ENV = nil, nil
multiClientInitialize.client_country = ""
function multiClientInitialize.recordZainCountry(...)
	multiClientInitialize.client_country = "unknow"
	local kingdomID = SoraDConfigGet("Game:LoginView:setKingdomID~integer")
	local languageString = GameLanguageCopy
	local noticeURL = SoraDGetNoticeURL() .. "?kid=" .. kingdomID .. "&language=" .. languageString
	local method = "GET"
	SoraDHttpRequest(function(tabel)
		if tabel and type(tabel) == "table" and tabel.country then
			multiClientInitialize.client_country = tabel.country
		end
	end, noticeURL, method)
end
function multiClientInitialize.judgeUserIsOnline2CallSDK2Push()
	local gametop = gModuleMgr.getObject("gametop")
	local timeCtrl = gametop.playertop_:getModule("timeCtrl")
	_ENV = nil
	;(nil).checkServerIsOK4SDKCallBack = true
	timeCtrl:getServerTimeReq(nil)
end
