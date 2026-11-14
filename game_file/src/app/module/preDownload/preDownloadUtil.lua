local _ENV, preDownloadUtil
local gametop = gModuleMgr.getObject("gametop")
local preDownloadCtrl = gametop.playertop_:getModule("preDownloadCtrl")
_ENV = gametop.playertop_
gametop.playertop_.DOWNLOAD_STATUS_NORMAL = 1
gametop.playertop_.DOWNLOAD_STATUS_DOWN_UNACTIVE = 2
gametop.playertop_.DOWNLOAD_STATUS_DOWNING = 3
gametop.playertop_.DOWNLOAD_STATUS_DOWN_COMPLE = 4
gametop.playertop_.DOWNLOAD_STATUS_DOWN_PAUSE = 5
local gametop.playertop_.DOWNLOAD_STATUS_DOWN_PAUSE_NETWORK, DOWNLOAD_STATUS = 6, gametop.playertop_
preDownloadUtil.DOWNLOAD_STATUS = DOWNLOAD_STATUS
function preDownloadUtil.getPreDownloadStatus()
	if not preDownloadCtrl:isActivityOpen() then
		return DOWNLOAD_STATUS.DOWNLOAD_STATUS_NORMAL
	end
	if preDownloadCtrl:isPlayerDownloaded() then
		return DOWNLOAD_STATUS.DOWNLOAD_STATUS_DOWN_COMPLE
	end
	if preDownloadCtrl:isPreFileDownloadComplete() then
		return DOWNLOAD_STATUS.DOWNLOAD_STATUS_DOWN_COMPLE
	end
	if preDownloadCtrl:isPlayerActive() then
		if preDownloadCtrl:isPlayerPause() then
			return DOWNLOAD_STATUS.DOWNLOAD_STATUS_DOWN_PAUSE
		elseif preDownloadCtrl:isPreFileDownloading() then
			return DOWNLOAD_STATUS.DOWNLOAD_STATUS_DOWNING
		else
			return DOWNLOAD_STATUS.DOWNLOAD_STATUS_DOWN_PAUSE_NETWORK
		end
	end
	return DOWNLOAD_STATUS.DOWNLOAD_STATUS_DOWN_UNACTIVE
end
function preDownloadUtil.setShowPreDownloadWidgetCfg(show)
	_ENV = nil
	;(nil).byUID = true
	local list = SoraDConfigGet("Game:preDownload:showWidgetCfg~table", nil)
	if not list then
		list, _ENV = "Game:preDownload:showWidgetCfg~table", "Game:preDownload:showWidgetCfg~table"
	end
	local round = preDownloadCtrl:getActivieyRound()
	list[tostring(round)] = show
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:preDownload:showWidgetCfg~table", list, nil)
end
function preDownloadUtil.getShowPreDownloadWidgetCfg()
	_ENV = nil
	;(nil).byUID = true
	local list = SoraDConfigGet("Game:preDownload:showWidgetCfg~table", nil)
	if list then
		local round = preDownloadCtrl:getActivieyRound()
		return list[tostring(round)]
	end
	return false
end
function preDownloadUtil.isShowPreDownloadWidget()
	return preDownloadCtrl:isActivityOpen()
end
function preDownloadUtil.checkPreDownloadAutoStart()
	preDownloadCtrl:checkPreDownloadAutoStart()
	preDownloadCtrl:checkSendPredownloadOk()
end
function preDownloadUtil.checkSendPredownloadOk()
	preDownloadCtrl:checkSendPredownloadOk()
end
function preDownloadUtil.getVersionContent()
	local param = preDownloadCtrl:getActivityParam()
	local tips = ""
	if param and param.text then
		local text = param.text
		local lan = SoraDGetDefaultLanguage()
		local content
		if text[lan] then
			content = text[lan]
		else
			lan = _G.IsArClient and "ar" or "en"
			content = text[lan]
		end
		if content and content.content then
			tips = content.content
		end
	end
	return tips
end
return preDownloadUtil
