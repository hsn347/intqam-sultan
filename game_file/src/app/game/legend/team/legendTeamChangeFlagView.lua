local gametop = gModuleMgr.getObject("gametop")
local legendTeamCtrl = gametop.playertop_:getModule("legendTeamCtrl")
local allianceDesRead = include("allianceDesRead")
local legendTeamChangeFlagView = class("legendTeamChangeFlagView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("legendTeamChangeFlagView")
	end
	return target
end)
function legendTeamChangeFlagView:ctor()
	self.isHidePrePanel = false
	self:setBackGround(204.0)
	self.tableFlagSingle, _ENV, self.tableFlagList, _ENV, self.curFlag = self.setBackGround, self.setBackGround, self.setBackGround, self.setBackGround, 0
	self.scrollFlag = SoraDGetChildByName(self, "ScrollView_flag")
	self.btnFlag = SoraDGetChildByName(self, "Button_flag")
	self.imgFrame = SoraDGetChildByName(self, "Image_frame")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.nodeFlagSingle = SoraDGetChildByName(self, "Node_flag_single")
	self.btnCancel = SoraDGetChildByName(self, "Button_cancel")
	self.btnCancel:setTitleText(i18n("common_text_184"))
	self.btnChange = SoraDGetChildByName(self, "Button_change")
	self.btnChange:setTitleText(i18n("common_text_243"))
	self.btnFlag:addTouchEventListener(handler(self, self.btnFlagClickCallBack))
	self.btnCancel:addTouchEventListener(function(ref, type)
		if type == ccui.TouchEventType.ended then
			SoraDPlaySound()
			self:close(ref, type)
		end
	end)
	self.btnChange:addTouchEventListener(handler(self, self.btnChangeClickCallBack))
	_ENV = handler(self, self.btnChangeClickCallBack)
	handler(self, self.btnChangeClickCallBack).bg = self.btnFlag
	handler(self, self.btnChangeClickCallBack).flag = self.nodeFlagSingle
	table.insert(self.tableFlagSingle, handler(self, self.btnChangeClickCallBack))
	self:initData()
end
function legendTeamChangeFlagView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_CHANGE_FLAG", handler(self, self.updateView))
end
function legendTeamChangeFlagView:updateView()
	for _, v in ipairs(self.tableFlagSingle) do
		v.flag:setVisible(false)
		v.bg:setVisible(false)
	end
	self:initData()
	SoraDCloseLoading(self)
end
function legendTeamChangeFlagView:updateFlag()
	self.curFlag = legendTeamCtrl:getTeamFlag()
	self.nodeFlag:removeAllChildren()
	allianceDesRead.getFlagWithParticle(self.curFlag, self.nodeFlag)
end
function legendTeamChangeFlagView:initData()
	self:updateFlag()
	self.tableFlagList = allianceDesRead.getFlagList(true)
	self.imgFrame:setVisible(false)
	self.nodeFlagSingle:setVisible(false)
	self.btnFlag:setVisible(false)
	self.btnChange:setTouchEnabled(false)
	self.btnChange:setBright(false)
	local scrollW = 185 * #self.tableFlagList + 455.0
	local flagOffX = SoraDFPosX(scrollW, 0)
	for i, v in ipairs(self.tableFlagList) do
		local flagButton, flagSprite
		if i == 1 then
			flagButton = self.btnFlag
			flagSprite = self.nodeFlagSingle
			flagButton:setPositionX(320)
			flagSprite:setPositionX(320)
			flagSprite:removeAllChildren()
			allianceDesRead.getFlagWithParticle(v, flagSprite)
		elseif self.tableFlagSingle[i] then
			flagButton = self.tableFlagSingle[i].bg
			flagSprite = self.tableFlagSingle[i].flag
			flagSprite:removeAllChildren()
			allianceDesRead.getFlagWithParticle(v, flagSprite)
		else
			flagButton = self.btnFlag:clone()
			flagSprite = self.nodeFlagSingle:clone()
			flagSprite = allianceDesRead.getFlagWithParticle(v, flagSprite)
			allianceDesRead = flagSprite
			flagSprite.bg = flagButton
			flagSprite.flag = flagSprite
			table.insert(self.tableFlagSingle, flagSprite)
			flagButton:addTouchEventListener(handler(self, self.btnFlagClickCallBack))
			flagButton:addTo(self.scrollFlag)
			flagSprite:addTo(self.scrollFlag)
		end
		flagButton:setPositionX(self.btnFlag:getPositionX() + (i - 1) * 185)
		flagSprite:setPosition(cc.p(self.btnFlag:getPositionX() + (i - 1) * 185, self.btnFlag:getPositionY()))
		flagSprite:setScale(0.8)
		flagButton:setVisible(true)
		flagSprite:setVisible(true)
		if v == self.curFlag then
			self.imgFrame:setVisible(true)
			flagOffX = flagButton:getPositionX()
			self.imgFrame:setPositionX(flagOffX)
		end
		flagButton:setTag(v)
	end
	self.scrollFlag:setInnerContainerSize(cc.size(scrollW, 220))
	self.scrollFlag:jumpToPercentHorizontal(math.min(100, math.max(0, 100 * ((flagOffX - 320) / (scrollW - 640)))))
end
function legendTeamChangeFlagView:btnChangeClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowLoading(self)
		legendTeamCtrl:reqTeamSetFlag(self.curFlag)
	end
end
function legendTeamChangeFlagView:btnFlagClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local flagOffX = button:getPositionX()
		local scrollW = 185 * #self.tableFlagList + 455.0
		self.curFlag = button:getTag()
		self.imgFrame:setVisible(true)
		self.imgFrame:setPositionX(flagOffX)
		self.nodeFlag:removeAllChildren()
		allianceDesRead.getFlagWithParticle(self.curFlag, self.nodeFlag)
		local isOwnFlag = self.curFlag == legendTeamCtrl:getTeamFlag()
		self.btnChange:setTouchEnabled(not isOwnFlag)
		self.btnChange:setBright(not isOwnFlag)
		self.scrollFlag:scrollToPercentHorizontal(math.min(math.max(0, 100 * (flagOffX - 320) / (scrollW - 640)), 100), 0.5, true)
	end
end
return legendTeamChangeFlagView
