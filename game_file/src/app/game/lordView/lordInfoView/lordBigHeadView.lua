local LordBigHeadView = class("lordBigHeadView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("lordBigHeadView")
	end
	return target
end)
function LordBigHeadView:ctor()
	self:setBackGround(0)
	self:setSwallowTouches(false)
	self.avatar = ""
	self.headid = 0
	SoraDGetChildByName(self, "Image_1"):setFillType(1)
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.img1 = SoraDGetChildByName(self, "Image_1")
	self.imgHead = SoraDGetChildByName(self, "Image_head")
	self.imgBgNoSize = SoraDGetChildByName(self, "Image_bg_noSize")
	self.btnDownload = SoraDGetChildByName(self, "Button_download")
	self.imgBlack = SoraDGetChildByName(self, "Image_black")
	self.labelDownload = SoraDGetChildByName(self, "Text_download")
	self.labelDownload:setString(i18n("common_text_3832"))
	if self.btnDownload then
		self.btnDownload:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BIG_HEAD", function(target, data)
		print("receive msg")
		if data.avatar == self.avatar then
			self:updateBigHead(self.avatar, self.headid)
			if data.ret then
				self:hideDownloadBtn()
			else
				self:stopAllActions()
				self.labelDownload:setString(i18n("common_text_3832"))
			end
		end
	end)
end
function LordBigHeadView:updateBigHead(avatar, headid)
	self.avatar = avatar
	self.headid = headid
	if SoraDHasHeadFromManager(self.avatar, true) then
		SoraDGetHeadFromManager(self.imgHead, self.headid, self.avatar, true)
		self:hideDownloadBtn()
	else
		SoraDGetHeadFromManager(self.imgHead, self.headid, self.avatar)
	end
end
function LordBigHeadView:hideDownloadBtn()
	self.labelDownload:setVisible(false)
	self.imgBlack:setVisible(false)
	self.btnDownload:setVisible(false)
	self:stopAllActions()
end
function LordBigHeadView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:showLoading()
		SoraDPlayerHeadDownload(self.avatar, true, true)
	end
end
function LordBigHeadView:showLoading()
	local dt = 0.6
	_UPVALUE5_ = nil
	;(nil)[1] = cca.callFunc(function(...)
		self.labelDownload:setString("..")
	end)
	;(nil)[2] = cca.delay(dt)
	;(nil)[3] = cca.callFunc(function(...)
		self.labelDownload:setString("....")
	end)
	;(nil)[4] = cca.delay(dt)
	;(nil)[5] = cca.callFunc(function(...)
		self.labelDownload:setString("......")
	end)
	;(nil)[6] = cca.delay(dt)
	;(nil)[7] = cca.delay(dt)
	self:runAction(cca.repeatForever(cca.seq(nil)))
end
return LordBigHeadView
