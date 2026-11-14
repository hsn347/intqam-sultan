local lordLocalData = include("lordLocalData")
local mailItemDetailAlliancePlayer = class("mailItemDetailAlliancePlayer", function(target)
	return SoraDCreateBasePanel("mailItemDetailAlliancePlayer")
end)
function mailItemDetailAlliancePlayer:ctor()
	self:setCascadeOpacityEnabled(true)
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	self.layout_content:setSwallowTouches(false)
	self.itemWidth = self.layout_content:getContentSize().width
	self.itemHeight = self.layout_content:getContentSize().height
	self.img_player = SoraDGetChildByName(self, "img_player")
	self.text_power_name = SoraDGetChildByName(self, "text_power_name")
	self.text_power_value = SoraDGetChildByName(self, "text_power_value")
	self.text_name = SoraDGetChildByName(self, "text_name")
	self.btn_player = SoraDGetChildByName(self, "btn_player")
	if self.btn_player then
		self.btn_player:setSwallowTouches(false)
		self.btn_player:addTouchEventListener(handler(self, self.btnPlayerEvent))
	end
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailItemDetailAlliancePlayer:initWithData(mail)
	self.mail = mail
	local contentData = self.mail:getProperty("data")
	local targetAid = contentData.aid
	local iconID = contentData.uinfo.iconID
	local bustImgName = lordLocalData.getBust(iconID)
	self.img_player:loadTexture(bustImgName, ccui.TextureResType.plistType)
	self.text_power_name:setString(i18n("common_text_090"))
	self.text_power_value:setString(tostring(contentData.uinfo.totalFc))
	self.text_power_value:setPositionX(self.text_power_name:getPositionX() + SoraDFPosX(-self.text_power_name:getContentSize().width, 0))
	self.text_name:setString(contentData.uinfo.nickName)
end
function mailItemDetailAlliancePlayer:getItemWidth()
	return self.itemWidth
end
function mailItemDetailAlliancePlayer:getItemHeight()
	return self.itemHeight
end
function mailItemDetailAlliancePlayer:btnPlayerEvent(target, event)
	print("mailItemDetailAlliancePlayer", event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		local playerId = self.mail.property.sender
		local mid = self.mail.property.mid
		_ENV = nil
		;(nil).targetName = "mailItemDetailView"
		;(nil).isFromMail = true
		;(nil).mid = mid
		SoraDGetCtrl("lordInfoCtrl"):getLordInfoByUid(playerId, kid, nil)
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
return mailItemDetailAlliancePlayer
