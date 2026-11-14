local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
_ENV, _ENV = nil, "soldierRushCtrl"
_UPVALUE1_, ("soldierRushCtrl")[1], (nil)[1] = nil, nil, cc.p(106, 36)
_UPVALUE1_, ("soldierRushCtrl")[1], (nil)[2] = nil, nil, cc.p(106, 36)
_UPVALUE1_, ("soldierRushCtrl")[1], (nil)[3] = nil, nil, cc.p(106, 36)
_UPVALUE1_, ("soldierRushCtrl")[1], (nil)[4] = nil, nil, cc.p(106, 36)
_UPVALUE1_, ("soldierRushCtrl")[1], (nil)[5] = nil, nil, cc.p(106, 36)
_UPVALUE2_, ("soldierRushCtrl")[2], (nil)[1] = nil, nil, cc.p(141, 36)
_UPVALUE2_, ("soldierRushCtrl")[2], (nil)[2] = nil, nil, cc.p(71, 36)
_UPVALUE2_, ("soldierRushCtrl")[2], (nil)[3] = nil, nil, cc.p(71, 36)
_UPVALUE2_, ("soldierRushCtrl")[2], (nil)[4] = nil, nil, cc.p(71, 36)
_UPVALUE2_, ("soldierRushCtrl")[2], (nil)[5] = nil, nil, cc.p(71, 36)
;("soldierRushCtrl")[3], (nil)[1] = nil, cc.p(176, 26)
;("soldierRushCtrl")[3], (nil)[2] = nil, cc.p(106, 36)
;("soldierRushCtrl")[3], (nil)[3] = nil, cc.p(36, 26)
;("soldierRushCtrl")[3], (nil)[4] = nil, cc.p(36, 26)
;("soldierRushCtrl")[3], (nil)[5] = nil, cc.p(36, 26)
local posCfg = "soldierRushCtrl"
local baseComponent = require("fgui.base.baseComponent")
local Com_menu = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_menu", Com_menu)
function Com_menu:onInit()
end
function Com_menu:onShow()
end
function Com_menu:init(bid, gateID)
	self.bid = bid
	self.gateID = gateID
	local index = 0
	local toID = soldierRushRead.getChapterLevel(soldierRushCtrl:getToGateIndex())
	local cfgID1, cfgID2, cfgID3
	local buildInfo = soldierRushCtrl:getBuildInfo(bid)
	local bType = buildInfo.bType
	local soldierRushRead, showBtns = bid, bid
	for i = 1, 4 do
		self.fields["n" .. i]:initData(i, bid, gateID)
		self.fields["n" .. i]:setVisible(false)
		if i == 4 then
			cfgID3 = soldierRushRead.getConstantVal("Switch_Type_Build3")
			if toID >= cfgID3 and bType ~= 3 then
				table.insert(showBtns, self.fields["n" .. i])
			end
		elseif i == 3 then
			cfgID2 = soldierRushRead.getConstantVal("Switch_Type_Build2")
			if toID >= cfgID2 and bType ~= 2 then
				table.insert(showBtns, self.fields["n" .. i])
			end
		elseif i == 1 then
			table.insert(showBtns, self.fields["n" .. i])
		elseif i == 2 then
			cfgID1 = soldierRushRead.getConstantVal("Switch_Type_Build1")
			if toID >= cfgID1 and bType ~= 1 then
				table.insert(showBtns, self.fields["n" .. i])
			end
		end
	end
	local posArray = posCfg[#showBtns]
	for k, v in ipairs(showBtns) do
		v:setVisible(true)
		v:setPosition(posArray[k])
	end
end
function Com_menu:update()
	if self.bid and self.gateID then
		for i = 1, 4 do
			self.fields["n" .. i]:initData(i, self.bid, self.gateID)
		end
	end
end
function Com_menu:getUpgradeBtn()
	return self.fields.n1
end
function Com_menu:getTowerBtn()
	return self.fields.n3
end
function Com_menu:getBuffBtn()
	return self.fields.n4
end
return Com_menu
