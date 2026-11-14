local gametop = gModuleMgr.getObject("gametop")
local allianceScience = gametop.playertop_:getModule("allianceScience")
local AllianceScienceBtn = class("allianceScienceBtn", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceScienceBtn")
	end
	return target
end)
function AllianceScienceBtn:ctor()
	_ENV, _ENV = nil, nil
	;(nil).key = gAScienceLv.JUNIOR_USE
	_ENV, (nil).res, (nil).data = nil, nil, 0
	;(nil).key = gAScienceLv.JUNIOR_HONOR
	_ENV, (nil).honor, (nil).data = nil, nil, 0
	;(nil).key = gAScienceLv.JUNIOR_HONOR
	_ENV, (nil).score, (nil).data = nil, nil, 0
	;(nil).key = gAScienceLv.JUNIOR_SCI_POINT
	;(nil).spoint, (nil).data = nil, 0
	self.tableBtnData, _ENV, self.tableDonateData, (nil).type = nil, nil, nil, gAScienceDonateType.Junior
	self.handle = nil
	self.resEnough = false
	self.rid = nil
	self.spriteIcon = SoraDGetChildByName(self, "Sprite_res")
	self.btnDonate = SoraDGetChildByName(self, "Button_donate")
	self.labelNeed = SoraDGetChildByName(self, "Text_need")
	self.labelPoint = SoraDGetChildByName(self, "Text_point")
	self.labelScore = SoraDGetChildByName(self, "Text_score")
	self.spriteHonor = SoraDGetChildByName(self, "Sprite_honor")
	self.spriteScore = SoraDGetChildByName(self, "Sprite_score")
	self.labelScoreAdd = SoraDGetChildByName(self, "Text_scoreAdd")
	self.labelHonorAdd = SoraDGetChildByName(self, "Text_honorAdd")
	self.labelScoreAdd:setVisible(false)
	self.labelHonorAdd:setVisible(false)
	self.labelHonor = SoraDGetChildByName(self, "Text_honor")
	self.labelGet = SoraDGetChildByName(self, "Text_buy")
	if self.btnDonate then
		self.btnDonate:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	self:btnStateChange(false)
end
function AllianceScienceBtn:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.resUpdate))
end
function AllianceScienceBtn:setHandle(handle)
	self.handle = handle
end
function AllianceScienceBtn:setDonateType(type)
	self.tableDonateData.type = type
end
function AllianceScienceBtn:initData(btnData)
	self.tableBtnData = btnData
	self:updateView()
end
function AllianceScienceBtn:updateView()
	local allianceltCtrl = include("allianceltCtrl")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	if self.tableDonateData.type == gAScienceDonateType.Junior then
		self.tableDonateData.res.key = gAScienceLv.JUNIOR_USE
		self.tableDonateData.honor.key = gAScienceLv.JUNIOR_HONOR
		self.tableDonateData.score.key = gAScienceLv.JUNIOR_HONOR
		self.tableDonateData.spoint.key = gAScienceLv.JUNIOR_SCI_POINT
		self.btnDonate:loadTextureNormal("btn_yellow_normal_01.png", ccui.TextureResType.plistType)
		self.btnDonate:loadTexturePressed("", ccui.TextureResType.plistType)
	elseif self.tableDonateData.type == gAScienceDonateType.Middle then
		self.tableDonateData.res.key = gAScienceLv.MIDDLE_USE
		self.tableDonateData.honor.key = gAScienceLv.MIDDLE_HONOR
		self.tableDonateData.score.key = gAScienceLv.MIDDLE_HONOR
		self.tableDonateData.spoint.key = gAScienceLv.MIDDLE_SCI_POINT
	elseif self.tableDonateData.type == gAScienceDonateType.Senior then
		self.tableDonateData.res.key = gAScienceLv.SENIOR_USE
		self.tableDonateData.honor.key = gAScienceLv.SENIOR_HONOR
		self.tableDonateData.score.key = gAScienceLv.SENIOR_HONOR
		self.tableDonateData.spoint.key = gAScienceLv.SENIOR_SCI_POINT
	end
	self.rid = nil
	local member = memberMgr:getOwnMember()
	self.rid = member:getDonateData(self.tableBtnData.id, self.tableBtnData.lv, self.tableDonateData.type)
	self.tableDonateData.res.data = allianceltCtrl.scienceLvInfo(self.tableBtnData.id, self.tableBtnData.lv, self.tableDonateData.res.key)
	self.tableDonateData.honor.data = allianceltCtrl.scienceLvInfo(self.tableBtnData.id, self.tableBtnData.lv, self.tableDonateData.honor.key)
	self.tableDonateData.score.data = allianceltCtrl.scienceLvInfo(self.tableBtnData.id, self.tableBtnData.lv, self.tableDonateData.score.key)
	self.tableDonateData.spoint.data = allianceltCtrl.scienceLvInfo(self.tableBtnData.id, self.tableBtnData.lv, self.tableDonateData.spoint.key)
	self.labelNeed:setColor(display.COLOR_WHITE)
	self.resEnough = false
	if self.rid then
		local resDesRead = include("resDesRead")
		self.tableDonateData.res.data = allianceltCtrl.getDonateCost(self.tableBtnData.id, self.tableBtnData.lv, self.tableDonateData.type, self.rid)
		self.spriteIcon:setSpriteFrame(resDesRead.getMIcon(self.rid))
		self:resUpdate()
	end
	self.labelNeed:setString(string.formatnumberthousands(self.tableDonateData.res.data))
	self.labelPoint:setString(string.formatnumberthousands(self.tableDonateData.spoint.data))
	self.labelHonor:setString(string.formatnumberthousands(self.tableDonateData.honor.data))
	self.labelScore:setString(string.formatnumberthousands(self.tableDonateData.score.data))
	self:btnStateChange(self.rid ~= nil)
	self:updateAdd()
end
function AllianceScienceBtn:updateAdd()
	local honorAdd = allianceScience:getDonateHonorAdd()
	local scoreAdd = allianceScience:getDonateScoreAdd()
	if 0 < honorAdd then
		self:addEffect(self.spriteHonor, true)
		allianceScience = nil
		;(nil).value = string.formatnumberthousands(self.tableDonateData.honor.data * honorAdd)
		self.labelHonorAdd:setString(i18n("common_text_1952", nil))
		self.labelHonorAdd:setVisible(true)
	else
		self:addEffect(self.spriteHonor, true, true)
		self.labelHonorAdd:setVisible(false)
	end
	if 0 < scoreAdd then
		self:addEffect(self.spriteScore)
		allianceScience = true
		;(true).value = string.formatnumberthousands(self.tableDonateData.score.data * scoreAdd)
		self.labelScoreAdd:setString(i18n("common_text_1952", true))
		self.labelScoreAdd:setVisible(true)
	else
		self:addEffect(self.spriteScore, false, true)
		self.labelScoreAdd:setVisible(false)
	end
end
function AllianceScienceBtn:addEffect(target, isHonor, remove)
	local effect = SoraDGetChildByName(target, "activityNode")
	if remove then
		if effect then
			effect:removeFromParent()
		end
	else
		_ENV, _ENV = effect, effect.removeFromParent
		effect.plist = "et_alliance_activities_01.plist"
		_ENV, effect.removeFromParent[1], effect.scale = effect, effect, 1
		effect.plist = "et_alliance_activities_02.plist"
		_ENV, _ENV, effect.removeFromParent[2], effect.scale = nil, effect, effect, 1
		local param1 = effect.removeFromParent
		;(nil).plist = "et_alliance_activities_03.plist"
		_ENV, effect[1], (nil).scale = nil, nil, 2
		;(nil).plist = "et_alliance_activities_04.plist"
		effect[2], (nil).scale = nil, 2
		local param2 = effect
		if effect == nil then
			if isHonor then
				effect = SoraDCreateEffectNode(param1)
			else
				effect = SoraDCreateEffectNode(param2)
			end
			effect:setName("activityNode")
			effect:setPosition(cc.p(target:getContentSize().width / 2, target:getContentSize().height / 2))
			effect:addTo(target, 1)
		end
	end
end
function AllianceScienceBtn:resUpdate()
	if self.rid then
		if SoraDEnoughRes(self.rid, self.tableDonateData.res.data) then
			self.resEnough = true
			self.labelNeed:setColor(display.COLOR_WHITE)
		else
			self.labelNeed:setColor(display.COLOR_RED)
		end
	end
end
function AllianceScienceBtn:btnStateChange(isCanTouch, showIcon)
	self.btnDonate:setBright(isCanTouch)
	if not showIcon then
		self.spriteIcon:setVisible(isCanTouch)
		if not isCanTouch then
			self.labelNeed:setString("")
			self.btnDonate:setTitleText("???")
		else
			self.btnDonate:setTitleText("")
		end
	end
end
function AllianceScienceBtn:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not button:isBright() then
			return
		end
		SoraDPlaySound()
		if include("pyramidWarltCtrl").checkPwXianXiaSai() then
			if self.resEnough then
				if self.handle then
					self.handle(self.tableBtnData.id, self.tableDonateData.type)
				end
			elseif self.rid == gIDDef.GOLD then
				SoraDEnoughGold(self.tableDonateData.res.data)
			else
				_ENV = nil
				;(nil).rid = self.rid
				uiManager:show("resourceBuyView", nil)
			end
		end
	end
end
return AllianceScienceBtn
