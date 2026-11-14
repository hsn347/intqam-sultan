local gametop = gModuleMgr.getObject("gametop")
local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
local alliancePetRead = include("alliancePetRead")
local baseComponent = require("fgui.base.baseComponent")
local alliancePetDonateBtn = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AlliancePetView/alliancePetDonateBtn", alliancePetDonateBtn)
local string_fnt = string.formatnumberthousands
function alliancePetDonateBtn:onInit()
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
	self.btnDonate = self.fields.Button_donate
	self.btnDonate:addClickListener(handler(self, self.btnClickCallBack))
	self.labelNeed = self.btnDonate:getChild("Text_gold")
	self.spriteIcon = self.btnDonate:getChild("Icon_gold")
	self.labelPoint = self.fields.Com_item1
	self.labelScore = self.fields.Com_item2
	self.labelHonor = self.fields.Com_item3
	self:btnStateChange(false)
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.resUpdate))
	if not SoraDFIsRA() then
		self.labelPoint:fixChildrenPos()
		self.labelScore:fixChildrenPos()
		self.labelHonor:fixChildrenPos()
	end
end
function alliancePetDonateBtn:onShow()
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
	if self.tableDonateData.type == gAScienceDonateType.Junior then
		self.tableDonateData.res.key = "Use1"
		self.tableDonateData.honor.key = "GetHonor1"
		self.tableDonateData.score.key = "GetHonor1"
		self.tableDonateData.spoint.key = "GetPoint1"
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
		self[v.widget]:setString(string_fnt(v.data))
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
	self.btnDonate:setPrice(resValue)
	self.resEnough = false
	if self.rid then
		local resDesRead = include("resDesRead")
		if resDesRead.getMIcon(self.rid) then
			self.spriteIcon:setURL(resDesRead.getMIcon(self.rid))
		end
		self:resUpdate()
	end
	self:btnStateChange(alliancePetCtrl:checkDonateType(self.tableDonateData.type))
end
function alliancePetDonateBtn:resUpdate()
	if self.rid then
		if SoraDEnoughRes(self.rid, self.tableDonateData.res.data) then
			self.resEnough = true
			self.btnDonate:setStatus(1, 0)
		else
			self.resEnough = false
			self.btnDonate:setStatus(0, 1)
		end
	end
end
function alliancePetDonateBtn:btnStateChange(isCanTouch, showIcon)
	self.btnDonate:setEnabled(isCanTouch)
	if not showIcon then
		self.spriteIcon:setVisible(isCanTouch)
		if not isCanTouch then
			self.btnDonate:setTitle("???")
		end
	end
end
function alliancePetDonateBtn:btnClickCallBack()
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
return alliancePetDonateBtn
