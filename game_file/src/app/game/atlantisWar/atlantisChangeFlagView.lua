local gametop = gModuleMgr.getObject("gametop")
local atlantisActivityCtrl = gametop.playertop_:getModule("atlantisActivityCtrl")
local allianceDesRead = include("allianceDesRead")
local atlantisChangeFlagView = class("atlantisChangeFlagView", include("allianceChangeFlagView"))
function atlantisChangeFlagView:ctor(...)
	self.super.ctor(self, ...)
	_ENV = ...
	....text = i18n("common_text_243")
	self.btnChange:initData(...)
	self.btnChange:addTouchEventListener(handler(self, self.btnChangeClickCallBack))
	self:initData()
end
function atlantisChangeFlagView:initData()
	self:updateFlag()
	_UPVALUE15_ = self.updateFlag
	self.tableFlagList, self.updateFlag[1] = self.updateFlag, 1
	self.tableFlagList, self.updateFlag[2] = self.updateFlag, 2
	self.tableFlagList, self.updateFlag[3] = self.updateFlag, 3
	self.tableFlagList, self.updateFlag[4] = self.updateFlag, 4
	self.tableFlagList, self.updateFlag[5] = self.updateFlag, 5
	self.tableFlagList, self.updateFlag[6] = self.updateFlag, 6
	self.tableFlagList, self.updateFlag[7] = self.updateFlag, 7
	self.tableFlagList, self.updateFlag[8] = self.updateFlag, 8
	self.tableFlagList, self.updateFlag[9] = self.updateFlag, 9
	self.tableFlagList, self.updateFlag[10] = self.updateFlag, 10
	self.tableFlagList, self.updateFlag[11] = self.updateFlag, 11
	self.tableFlagList, self.updateFlag[12] = self.updateFlag, 12
	self.tableFlagList, self.updateFlag[13] = self.updateFlag, 13
	self.tableFlagList, self.updateFlag[14] = self.updateFlag, 14
	self.tableFlagList, self.updateFlag[15] = self.updateFlag, 15
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
			_ENV = flagSprite
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
function atlantisChangeFlagView:updateView()
	self.super.updateView(self)
end
function atlantisChangeFlagView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_REFRESH", function(target, data)
		if data.key == "reqGetManagerInfoRsp" then
			SoraDCloseLoading(self)
			if data.rspdata then
				SoraDShowMsgTip(i18n("atlantiswar_text_0027"))
			else
				SoraDShowMsgTip(i18n("atlantiswar_text_0026"))
			end
			self:removeFromParent()
		end
	end)
end
function atlantisChangeFlagView:updateFlag()
	print("atlantisChangeFlagView:updateFlag")
	self.curFlag = atlantisActivityCtrl:getKingdomFlag()
	self.nodeFlag:removeAllChildren()
	allianceDesRead.getFlagWithParticle(self.curFlag, self.nodeFlag)
end
function atlantisChangeFlagView:btnChangeClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowLoading(self)
		atlantisActivityCtrl:reqModifyFlag(self.curFlag)
	end
end
function atlantisChangeFlagView:btnFlagClickCallBack(button, type)
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
		local isOwnFlag = self.curFlag == atlantisActivityCtrl:getKingdomFlag()
		self.btnChange:setTouchEnabled(not isOwnFlag)
		self.btnChange:setBright(not isOwnFlag)
		self.scrollFlag:scrollToPercentHorizontal(math.min(math.max(0, 100 * (flagOffX - 320) / (scrollW - 640)), 100), 0.5, true)
	end
end
return atlantisChangeFlagView
