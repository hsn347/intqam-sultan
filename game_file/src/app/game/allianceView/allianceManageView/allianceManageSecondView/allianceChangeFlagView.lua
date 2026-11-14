local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local allianceSetting = gametop.playertop_:getModule("allianceSetting")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local AllianceChangeFlagView = class("allianceChangeFlagView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceChangeFlagView")
	end
	return target
end)
function AllianceChangeFlagView:ctor()
	self.isHidePrePanel = false
	self:setBackGround(204.0)
	self.tableFlagSingle, _ENV, self.tableFlagList, _ENV, self.curFlag = self.setBackGround, self.setBackGround, self.setBackGround, self.setBackGround, 0
	self.timer = nil
	self.scrollFlag = SoraDGetChildByName(self, "ScrollView_flag")
	self.btnFlag = SoraDGetChildByName(self, "Button_flag")
	self.imgFrame = SoraDGetChildByName(self, "Image_frame")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.nodeFlagSingle = SoraDGetChildByName(self, "Node_flag_single")
	self.btnCancel = SoraDGetChildByName(self, "Button_cancel")
	self.btnCancel:setTitleText(i18n("common_text_184"))
	self.btnChange = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_change")
	_ENV = "CCS_commonGoldNormalBtn_change"
	;("CCS_commonGoldNormalBtn_change").title = i18n("common_text_243")
	self.btnChange:initData("CCS_commonGoldNormalBtn_change", 1)
	self.imgGold = SoraDGetChildByName(self, "Image_gold")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.labelFlagTime = SoraDGetChildByName(self, "Text_flagTime")
	self.labelTime:setVisible(false)
	self.labelFlagTime:setVisible(false)
	self.labelFlagTime:setLocalZOrder(3)
	self.btnFlag:addTouchEventListener(handler(self, self.btnFlagClickCallBack))
	self.btnCancel:addTouchEventListener(function(ref, type)
		if type == ccui.TouchEventType.ended then
			SoraDPlaySound()
			self:close(ref, type)
		end
	end)
	self.btnChange:addTouchEventListener(handler(self, self.btnChangeClickCallBack))
	self.btnChange:setGoldText(tostring(gConstValue.ALLIANCE_MODIFY_ALLIANCE_FLAG_GOLD))
	_ENV = tostring(gConstValue.ALLIANCE_MODIFY_ALLIANCE_FLAG_GOLD)
	tostring(gConstValue.ALLIANCE_MODIFY_ALLIANCE_FLAG_GOLD).bg = self.btnFlag
	tostring(gConstValue.ALLIANCE_MODIFY_ALLIANCE_FLAG_GOLD).flag = self.nodeFlagSingle
	table.insert(self.tableFlagSingle, tostring(gConstValue.ALLIANCE_MODIFY_ALLIANCE_FLAG_GOLD))
	self:initData()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_CHANGE_FLAG_SUCCESS", handler(self, self.updateView))
end
_ENV, AllianceChangeFlagView.updateView = function(self)
	for i, v in ipairs(self.tableFlagSingle) do
		v.flag:setVisible(false)
		v.bg:setVisible(false)
	end
	self.labelFlagTime:setVisible(false)
	self:initData()
	SoraDCloseLoading(self)
end, function(self)
	for i, v in ipairs(self.tableFlagSingle) do
		v.flag:setVisible(false)
		v.bg:setVisible(false)
	end
	self.labelFlagTime:setVisible(false)
	self:initData()
	SoraDCloseLoading(self)
end
;(function(self)
	for i, v in ipairs(self.tableFlagSingle) do
		v.flag:setVisible(false)
		v.bg:setVisible(false)
	end
	self.labelFlagTime:setVisible(false)
	self:initData()
	SoraDCloseLoading(self)
end)[16] = true
;(function(self)
	for i, v in ipairs(self.tableFlagSingle) do
		v.flag:setVisible(false)
		v.bg:setVisible(false)
	end
	self.labelFlagTime:setVisible(false)
	self:initData()
	SoraDCloseLoading(self)
end)[17] = true
;(function(self)
	for i, v in ipairs(self.tableFlagSingle) do
		v.flag:setVisible(false)
		v.bg:setVisible(false)
	end
	self.labelFlagTime:setVisible(false)
	self:initData()
	SoraDCloseLoading(self)
end)[18] = true
;(function(self)
	for i, v in ipairs(self.tableFlagSingle) do
		v.flag:setVisible(false)
		v.bg:setVisible(false)
	end
	self.labelFlagTime:setVisible(false)
	self:initData()
	SoraDCloseLoading(self)
end)[19] = true
local (function(self)
	for i, v in ipairs(self.tableFlagSingle) do
		v.flag:setVisible(false)
		v.bg:setVisible(false)
	end
	self.labelFlagTime:setVisible(false)
	self:initData()
	SoraDCloseLoading(self)
end)[20], showTimeFlag = true, function(self)
	for i, v in ipairs(self.tableFlagSingle) do
		v.flag:setVisible(false)
		v.bg:setVisible(false)
	end
	self.labelFlagTime:setVisible(false)
	self:initData()
	SoraDCloseLoading(self)
end
function AllianceChangeFlagView:updateFlag()
	self.curFlag = allianceMgr:getAllianceProperty("flag")
	self.nodeFlag:removeAllChildren()
	allianceDesRead.getFlagWithParticle(self.curFlag, self.nodeFlag)
	self.btnChange:setGoldText(tostring(allianceDesRead.getAllianceFlagPrice(self.curFlag)))
	self.labelTime:setVisible(showTimeFlag[self.curFlag])
	if allianceMgr:getAlliance():isInBestAllianceTime() and self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
		self:openTimeUp()
	end
	if allianceMgr:getAlliance():isMobiBestAlliance() and self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUpMobi))
		self:openTimeUpMobi()
	end
	if allianceMgr:getAlliance():isRamadanMobiTopAlliance() and self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUpMobi))
		self:openTimeUpRamadanMobi()
	end
end
function AllianceChangeFlagView:openTimeUp()
	if not allianceMgr:getAlliance():isInBestAllianceTime() then
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
	else
		local leftTime = allianceMgr:getAlliance():getBestAllianceInfo().endTime - serviceFunctions.systemTime()
		allianceMgr = nil
		;(nil).time = SoraDConvertSecondToString(leftTime)
		local str = i18n("common_text_766", nil)
		self.labelTime:setString(str)
		self.labelFlagTime:setString(str)
	end
end
function AllianceChangeFlagView:openTimeUpMobi()
	if not allianceMgr:getAlliance():isMobiBestAlliance() then
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
	else
		local leftTime = allianceMgr:getAlliance():getMobiBestAllianceInfo().endTime - serviceFunctions.systemTime()
		allianceMgr = nil
		;(nil).time = SoraDConvertSecondToString(leftTime)
		local str = i18n("common_text_766", nil)
		self.labelTime:setString(str)
		self.labelFlagTime:setString(str)
	end
end
function AllianceChangeFlagView:openTimeUpRamadanMobi()
	if not allianceMgr:getAlliance():isRamadanMobiTopAlliance() then
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
	else
		local leftTime = allianceMgr:getAlliance():getRamadanMobiTopAllianceInfo().endTime - serviceFunctions.systemTime()
		allianceMgr = nil
		;(nil).time = SoraDConvertSecondToString(leftTime)
		local str = i18n("common_text_766", nil)
		self.labelTime:setString(str)
		self.labelFlagTime:setString(str)
	end
end
function AllianceChangeFlagView:initData()
	self:updateFlag()
	self.tableFlagList = allianceDesRead.getFlagList()
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
		if v == 16 then
			self.labelFlagTime:setVisible(true)
			self.labelFlagTime:setPositionX(flagButton:getPositionX())
		end
	end
	self.scrollFlag:setInnerContainerSize(cc.size(scrollW, 220))
	self.scrollFlag:jumpToPercentHorizontal(math.min(100, math.max(0, 100 * ((flagOffX - 320) / (scrollW - 640)))))
end
function AllianceChangeFlagView:btnChangeClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not allianceDesRead.checkRank(gAllianceRank.R5) then
			SoraDShowMsgBox(i18n("common_text_674"), i18n("common_text_204"))
		elseif SoraDEnoughGold(allianceDesRead.getAllianceFlagPrice(self.curFlag)) then
			SoraDShowLoading(self)
			allianceSetting:reqModifyFlag(self.curFlag)
		end
	end
end
function AllianceChangeFlagView:btnFlagClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local flagOffX = button:getPositionX()
		local scrollW = 185 * #self.tableFlagList + 455.0
		self.curFlag = button:getTag()
		self.imgFrame:setVisible(true)
		self.imgFrame:setPositionX(flagOffX)
		self.nodeFlag:removeAllChildren()
		allianceDesRead.getFlagWithParticle(self.curFlag, self.nodeFlag)
		self.btnChange:setGoldText(tostring(allianceDesRead.getAllianceFlagPrice(self.curFlag)))
		self.labelTime:setVisible(self.curFlag == 16)
		local isOwnFlag = self.curFlag == allianceMgr:getAllianceProperty("flag")
		self.btnChange:setTouchEnabled(not isOwnFlag)
		self.btnChange:setBright(not isOwnFlag)
		self.scrollFlag:scrollToPercentHorizontal(math.min(math.max(0, 100 * (flagOffX - 320) / (scrollW - 640)), 100), 0.5, true)
	end
end
return AllianceChangeFlagView
