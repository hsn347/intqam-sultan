local gametop = gModuleMgr.getObject("gametop")
local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
local alliancePetRead = include("alliancePetRead")
local alliancePetDonateBtn = class("alliancePetDonateBtn", function(target)
	if target == nil then
		return SoraDCreateBasePanel("alliancePetDonateBtn")
	end
	return target
end)
function alliancePetDonateBtn:ctor()
	_ENV, _ENV = nil, nil
	;(nil).key = "Use1"
	;(nil).data = 0
	_ENV, (nil).res, (nil).widget = nil, nil, "labelNeed"
	;(nil).key = "GetHonor1"
	;(nil).data = 0
	_ENV, (nil).honor, (nil).widget = nil, nil, "labelPoint"
	;(nil).key = "GetHonor1"
	;(nil).data = 0
	_ENV, (nil).score, (nil).widget = nil, nil, "labelScore"
	;(nil).key = "GetPoint1"
	;(nil).data = 0
	;(nil).spoint, (nil).widget = nil, "labelHonor"
	self.tableDonateData, (nil).type = nil, gAScienceDonateType.Junior
	self.petType = nil
	self.handle = nil
	self.resEnough = false
	self.rid = nil
	self.spriteIcon = SoraDGetChildByName(self, "Sprite_res")
	self.btnDonate = SoraDGetChildByName(self, "Button_donate")
	self.labelNeed = SoraDGetChildByName(self, "Text_need")
	self.labelPoint = SoraDGetChildByName(self, "Text_row_1")
	self.labelScore = SoraDGetChildByName(self, "Text_row_2")
	self.labelHonor = SoraDGetChildByName(self, "Text_row_3")
	if self.btnDonate then
		self.btnDonate:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	self:btnStateChange(false)
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.resUpdate))
end
function alliancePetDonateBtn:setHandle(handle)
	self.handle = handle
end
function alliancePetDonateBtn:setDonateType(type)
	self.tableDonateData.type = type
end
function alliancePetDonateBtn:initData(petType)
	self.petType = petType
	self:updateView()
end
function alliancePetDonateBtn:updateView()
	local allianceltCtrl = include("allianceltCtrl")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	if self.tableDonateData.type == gAScienceDonateType.Junior then
		self.tableDonateData.res.key = "Use1"
		self.tableDonateData.honor.key = "GetHonor1"
		self.tableDonateData.score.key = "GetHonor1"
		self.tableDonateData.spoint.key = "GetPoint1"
		self.btnDonate:loadTextureNormal("btn_yellow_normal_01.png", ccui.TextureResType.plistType)
		self.btnDonate:loadTexturePressed("", ccui.TextureResType.plistType)
	elseif self.tableDonateData.type == gAScienceDonateType.Middle then
		self.tableDonateData.res.key = "Use2"
		self.tableDonateData.honor.key = "GetHonor2"
		self.tableDonateData.score.key = "GetHonor2"
		self.tableDonateData.spoint.key = "GetPoint2"
	elseif self.tableDonateData.type == gAScienceDonateType.Senior then
		self.tableDonateData.res.key = "Use3"
		self.tableDonateData.honor.key = "GetHonor3"
		self.tableDonateData.score.key = "GetHonor3"
		self.tableDonateData.spoint.key = "GetPoint3"
	end
	alliancePetCtrl = gAScienceDonateType.Senior
	gAScienceDonateType.Senior[1] = self.tableDonateData.honor
	gAScienceDonateType.Senior[2] = self.tableDonateData.score
	gAScienceDonateType.Senior[3] = self.tableDonateData.spoint
	for k, v in pairs(gAScienceDonateType.Senior) do
		v.data = alliancePetRead.getDonateDataByKey(self.petType, v.key)
		self[v.widget]:setString(v.data)
	end
	local resData = alliancePetRead.getDonateDataByKey(self.petType, self.tableDonateData.res.key)
	if "table" ~= type(resData) then
		resData, _ENV = type(resData), type(resData)
	end
	_ENV = self.tableDonateData.score
	self.tableDonateData.score.threePerHit = true
	resData = SoraDIntArr2FormatTable(resData, self.tableDonateData.score)
	local resID = alliancePetCtrl:getDonateResID(self.petType, self.tableDonateData.res.key)
	self.rid = resID
	local resValue = 0
	for i, v in ipairs(resData) do
		if v.id == self.rid then
			resValue = v.num
			break
		end
	end
	self.tableDonateData.res.data = resValue
	self.labelNeed:setString(resValue)
	self.labelNeed:setColor(display.COLOR_WHITE)
	self.resEnough = false
	if self.rid then
		local resDesRead = include("resDesRead")
		if resDesRead.getMIcon(self.rid) then
			self.spriteIcon:setSpriteFrame(resDesRead.getMIcon(self.rid))
		end
		self:resUpdate()
	end
	self:btnStateChange(alliancePetCtrl:checkDonateType(self.tableDonateData.type))
end
function alliancePetDonateBtn:resUpdate()
	if self.rid then
		if SoraDEnoughRes(self.rid, self.tableDonateData.res.data) then
			self.resEnough = true
			self.labelNeed:setColor(display.COLOR_WHITE)
		else
			self.resEnough = false
			self.labelNeed:setColor(display.COLOR_RED)
		end
	end
end
function alliancePetDonateBtn:btnStateChange(isCanTouch, showIcon)
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
function alliancePetDonateBtn:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not button:isBright() then
			return
		end
		SoraDPlaySound()
		if self.resEnough then
			if self.handle then
				self.handle(self.tableDonateData.type)
			end
		elseif self.rid == gIDDef.GOLD then
			SoraDEnoughGold(self.tableDonateData.res.data)
		elseif self.rid then
			local gametop = gModuleMgr.getObject("gametop")
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			_ENV, _ENV = "cityCtrl", gametop.playertop_
			;("cityCtrl").resid = self.rid
			;("cityCtrl").rescount = self.tableDonateData.res.data
			gametop.playertop_[1], ("cityCtrl").curcount = "cityCtrl", cityCtrl:getResCount(self.rid)
			local needList = gametop.playertop_
			_ENV = self.rid
			self.rid.rid = self.rid
			self.rid.needResData = needList
			uiManager:show("resourceBuyView", self.rid)
		end
	end
end
return alliancePetDonateBtn
