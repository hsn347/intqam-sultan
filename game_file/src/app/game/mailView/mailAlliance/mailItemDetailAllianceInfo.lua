local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local mailItemDetailAllianceInfo = class("mailItemDetailAllianceInfo", function(target)
	return include("ccsView").new(getCCSPath("mailItemDetailAllianceInfo"))
end)
function mailItemDetailAllianceInfo:ctor()
	self:setCascadeOpacityEnabled(true)
	self.singleIsMoved = false
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	self.itemWidth = self.layout_content:getContentSize().width
	self.itemHeight = self.layout_content:getContentSize().height
	self.btn_flag = SoraDGetChildByName(self, "btn_flag")
	self.btn_flag:setSwallowTouches(false)
	self.btn_flag:setPressedActionEnabled(true)
	self.btn_flag:addTouchEventListener(handler(self, self.onBtnFlag))
	self.Node_flag = SoraDGetChildByName(self.btn_flag, "Node_Flag")
	self.Node_flag:setCascadeOpacityEnabled(true)
	self.Node_flag:setScale(0.7)
	self.text_allianceName = SoraDGetChildByName(self, "text_allianceName")
	self.text_leader = SoraDGetChildByName(self, "text_leader")
	self.text_language = SoraDGetChildByName(self, "text_language")
	self.text_member = SoraDGetChildByName(self, "text_member")
	self.text_power = SoraDGetChildByName(self, "text_power")
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailItemDetailAllianceInfo:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
end
function mailItemDetailAllianceInfo:initWithData(mail)
	self.mail = mail
	self.contentData = self.mail:getProperty("data")
	local flag = self.contentData.allianceInfo.property.flag
	local flagImgName = allianceDesRead.getFlagIcon(flag)
	self.Node_flag:removeAllChildren()
	allianceDesRead.getFlagWithParticle(flag, self.Node_flag)
	self.text_allianceName:setString(self.contentData.allianceInfo.property.name)
	allianceDesRead = self.contentData.allianceInfo.property.name
	self.contentData.allianceInfo.property.name.name = self.contentData.allianceleadername or "TODO"
	local strLeader = i18n("common_text_170", self.contentData.allianceInfo.property.name)
	self.text_leader:setString(strLeader)
	self.text_power:setString(self.contentData.alliancepower)
	allianceDesRead = self.contentData.alliancepower
	self.contentData.alliancepower.member = #self.contentData.allianceInfo.memberlist
	self.contentData.alliancepower.total = self.contentData.allianceInfo.property.limitCount
	local strMember = i18n("common_text_155", self.contentData.alliancepower)
	self.text_member:setString(strMember)
	local strLanguage = allianceDesRead.getLanguageName(self.contentData.allianceInfo.property.language)
	self.text_language:setString(strLanguage)
end
function mailItemDetailAllianceInfo:getItemWidth()
	return self.itemWidth
end
function mailItemDetailAllianceInfo:getItemHeight()
	return self.itemHeight
end
function mailItemDetailAllianceInfo:onBtnFlag(target, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		local aid = self.contentData.allianceInfo.property.aid
		local gametop = gModuleMgr.getObject("gametop")
		local allianceQuery = gametop.playertop_:getModule("allianceQuery")
		_ENV = nil
		_ENV, (nil).aid = nil, aid
		;(nil).from = "mailDetail"
		allianceQuery:reqAllianceByID(nil, nil)
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
function mailItemDetailAllianceInfo:sMsgReqInfoBack(target, data)
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "mailDetail" then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
return mailItemDetailAllianceInfo
