local badgeExchangeCtrl = SoraDGetCtrl("badgeExchangeCtrl")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_arrow = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CollegeView/Com_arrow", Com_arrow)
function Com_arrow:onInit()
	self.iconArray, _UPVALUE0_, self.jiantouArray, _UPVALUE0_ = nil, nil, nil, nil
	self.fields.title:setString("")
end
function Com_arrow:onShow()
end
function Com_arrow:init(cfg)
	self.cfg = cfg
	self.fields.icon:setURL(publicRead.getIcon(self.cfg.targetID))
	self.fields.title:setString("")
	self.fields.txtName:setString(publicRead.getName(self.cfg.targetID))
	self.costArray = badgeExchangeCtrl:getCostCfg(self.cfg.badgeType)
	local initAng = -90
	local tmpAng = 360 / #self.costArray
	local r = 160
	local _r = 100
	for k, v in ipairs(self.jiantouArray) do
		v:setVisible(false)
	end
	for k, v in ipairs(self.iconArray) do
		v:setVisible(false)
	end
	for i = 1, #self.costArray do
		if not self.jiantouArray[i] then
			local jiantou = fguiHelper.createObject("CollegeView", "effect_jiantou")
			jiantou:addTo(self.fields.Com_empty, 0)
			self.jiantouArray[i] = jiantou
		else
			self.jiantouArray[i]:setVisible(true)
		end
		self.jiantouArray[i]:setRotation(initAng + (i - 1) * tmpAng)
		local rad = math.rad(tmpAng * (i - 1))
		self.jiantouArray[i]:setPosition(_r * math.sin(rad), -_r * math.cos(rad))
		if not self.iconArray[i] then
			local icon = fguiHelper.createObject("CollegeView", "Com_icon")
			icon:addTo(self.fields.Com_empty, 1)
			self.iconArray[i] = icon
		else
			self.iconArray[i]:setVisible(true)
		end
		self.iconArray[i]:initData(self.costArray[i])
		self.iconArray[i]:setPosition(r * math.sin(rad), -r * math.cos(rad))
	end
	self:runUnSelectAct()
	self.iconArray[1]:btnClick()
end
function Com_arrow:updateData(resID, num, badgeType)
	self.costArray = badgeExchangeCtrl:getCostCfg(self.cfg.badgeType)
	for k, v in ipairs(self.costArray) do
		local count = self.costArray[k].count
		if v.id == resID then
			count = badgeExchangeCtrl:getCostByType(v.id, num, badgeType)
		end
		badgeExchangeCtrl = v.id
		v.id.id = v.id
		v.id.count = count
		self.iconArray[k]:initData(v.id, resID)
	end
end
function Com_arrow:setResNum(str)
	self.fields.title:setString(str or "")
end
function Com_arrow:arrowAct(index)
	for i = 1, #self.costArray do
		self.jiantouArray[i]:setVisible(index == i)
		self.iconArray[i]:runIconAct(index == i)
	end
end
function Com_arrow:runUnSelectAct(exchangeID)
	self:stopAllActions()
	if not exchangeID then
		local index = 1
		_UPVALUE2_ = nil
		;(nil)[1] = ffa.callFunc(function()
			self:arrowAct(index)
		end)
		;(nil)[2] = ffa.delay(1.6)
		;(nil)[3] = ffa.callFunc(function()
			if index > #self.costArray then
			end
		end)
		;(nil)[4] = ffa.callFunc(function()
			if index > #self.costArray then
			end
		end)
		local seq = ffa.seq(nil)
		self:runAction(ffa.repeatForever(seq))
	else
		for i = 1, #self.costArray do
			self.jiantouArray[i]:setVisible(exchangeID == self.costArray[i].id)
			self.iconArray[i]:runIconAct(false)
		end
	end
end
return Com_arrow
