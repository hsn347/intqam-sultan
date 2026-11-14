local gametop = gModuleMgr.getObject("gametop")
local preDownloadCtrl = gametop.playertop_:getModule("preDownloadCtrl")
local preDownloadUtil = include("preDownloadUtil")
local DOWNLOAD_STATUS = preDownloadUtil.DOWNLOAD_STATUS
local preDownloadProgress = class("preDownloadProgress", function(target)
	if target == nil then
		return SoraDCreateBasePanel("preDownloadProgress")
	end
	return target
end)
function preDownloadProgress:ctor()
	self.lbProgress = SoraDGetChildByName(self, "LoadingBar_progress")
	self.txtProgress = SoraDGetChildByName(self, "Text_progress")
	self.spPoint = SoraDGetChildByName(self, "Sprite_point")
	self.btnInfo = SoraDGetChildByName(self, "Button_info")
	self.btnInfo:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.nodeInfo = SoraDGetChildByName(self, "Node_info")
	self.nodeProgress = SoraDGetChildByName(self, "Node_progress")
	self.txtKey = nil
end
function preDownloadProgress:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_PRE_DOWNLOAD_GAME_PROGRESS", handler(self, self.updateeProgress))
	SoraDAddMessage(self, "MESSAGE_PRE_DOWNLOAD_GAME_DOWNSUC", handler(self, self.updateeSuc))
end
function preDownloadProgress:initData(status)
	if status == DOWNLOAD_STATUS.DOWNLOAD_STATUS_DOWNING or status == DOWNLOAD_STATUS.DOWNLOAD_STATUS_DOWN_COMPLE then
		self.nodeProgress:setVisible(true)
	else
		self.nodeProgress:setVisible(false)
	end
	if preDownloadCtrl:isPlayerDownloaded() then
		self:updateeProgress_imp(1, 1)
	else
		local total = preDownloadCtrl:getSizeTotal()
		local downloaded = preDownloadCtrl:getSizeDownloading()
		self:updateeProgress_imp(downloaded, total)
	end
end
function preDownloadProgress:updateeProgress(target, data)
	local total = data.total
	local downloaded = data.downloaded
	if not total or not downloaded then
		return
	end
	self:updateeProgress_imp(downloaded, total)
end
function preDownloadProgress:updateeProgress_imp(downloaded, total)
	self.total = total
	self.downloaded = downloaded
	local percent = 0
	if 0 < total then
		percent = math.ceil(downloaded / total * 100)
	end
	self:setPrecent(percent)
end
function preDownloadProgress:updateeSuc(target, data)
	self.downloaded = self.total
	self:setPrecent(100)
end
function preDownloadProgress:setPrecent(percent)
	self.lbProgress:setPercent(percent)
	self.spPoint:setPositionX(self.lbProgress:getContentSize().width / 2 - self.lbProgress:getContentSize().width * percent / 100)
	SoraDFTarget(self.spPoint, nil, true)
	local txtKey
	if self.total <= 0 then
		txtKey = "download_first_button"
	elseif self.downloaded >= self.total then
		txtKey = "download_first_mail_title_08"
	else
		local strDownload = SoraDConvertNumberWithUnit(self.downloaded)
		local strTotal = SoraDConvertNumberWithUnit(self.total)
		_ENV = nil
		;(nil).var1 = strDownload
		;(nil).var2 = strTotal
		self.txtProgress:setString(i18n("download_first_description_03", nil))
	end
	if txtKey and txtKey ~= self.txtKey then
		self.txtKey = txtKey
		self.txtProgress:setString(i18n(txtKey))
	end
	_UPVALUE1_ = i18n(txtKey)
	i18n(txtKey)[1] = 10
	_G.SoraDAlignNodeArrayOnCenterX(0, self.nodeInfo:getChildren(), SoraDFIsRA(), i18n(txtKey))
end
function preDownloadProgress:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local msg = preDownloadUtil.getVersionContent()
		preDownloadUtil = "Community_text_0002"
		;("Community_text_0002")[1] = msg
		_ENV = nil
		;(nil).hideBtn = true
		;(nil).isHtml = true
		;(nil).showArrow = true
		SoraDShowFixWindow(i18n("Community_text_0002"), "Community_text_0002", nil, nil)
	end
end
return preDownloadProgress
