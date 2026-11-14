local BattleAttrTestView = class("BattleAttrTestView", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("commonTestView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
_ENV, _UPVALUE22_ = function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("commonTestView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end, "BattleAttrTestView"
;(function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("commonTestView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end).name = "步兵攻击"
;(function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("commonTestView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end).attr = "infantryAtk"
_ENV, (function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("commonTestView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end).default = nil, 0
;(nil).name = "步兵防御"
_ENV, (nil).attr = nil, "infantryDef"
;(nil).name = "步兵生命"
_ENV, (nil).attr = nil, "infantryHp"
;(nil).name = "步兵伤害"
_ENV, (nil).attr = nil, "infantryDmp"
;(nil).name = "骑兵攻击"
_ENV, (nil).attr = nil, "cavalryAtk"
;(nil).name = "骑兵防御"
_ENV, (nil).attr = nil, "cavalryDef"
;(nil).name = "骑兵生命"
_ENV, (nil).attr = nil, "cavalryHp"
;(nil).name = "骑兵伤害"
_ENV, (nil).attr = nil, "cavalryDmp"
;(nil).name = "弓兵攻击"
_ENV, (nil).attr = nil, "archerAtk"
;(nil).name = "弓兵防御"
_ENV, (nil).attr = nil, "archerDef"
;(nil).name = "弓兵生命"
_ENV, (nil).attr = nil, "archerHp"
;(nil).name = "弓兵伤害"
_ENV, (nil).attr = nil, "archerDmp"
;(nil).name = "车兵攻击"
_ENV, (nil).attr = nil, "charistsAtk"
;(nil).name = "车兵防御"
_ENV, (nil).attr = nil, "charistsDef"
;(nil).name = "车兵生命"
_ENV, (nil).attr = nil, "charistsHp"
;(nil).name = "车兵伤害"
_ENV, (nil).attr = nil, "charistsDmp"
;(nil).name = "骑兵对弓兵伤害"
_ENV, (nil).attr = nil, "CavalryToArcherDmp"
;(nil).name = "弓兵对步兵伤害"
_ENV, (nil).attr = nil, "ArcherToInfantryDmp"
;(nil).name = "步兵对骑兵伤害"
_ENV, (nil).attr = nil, "infantryToCavalryDmp"
;(nil).name = "弓兵暴击率"
_ENV, (nil).attr = nil, "ArcherCrit"
;(nil).name = "弓兵对步兵伤害减少"
_ENV, (nil).attr = nil, "ArcherToInfantryReduceDmp"
;(nil).name = "步兵闪避"
_ENV, (nil).attr = nil, "dodgePlus"
;(nil).name = "命中"
_ENV, (nil).attr = nil, "hitRatePlus"
;(nil).name = "忽视目标防御"
_ENV, (nil).attr = nil, "ignoreDef"
;(nil).name = "抵消步兵受到伤害"
_ENV, (nil).attr = nil, "reduceDmg"
;(nil).name = "出征上限"
_ENV, (nil).attr = nil, "marchMaxCount"
;(nil).name = "集结上限"
;(nil).attr = "massMaxCount"
;("BattleAttrTestView")[1] = function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("commonTestView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end
;("BattleAttrTestView")[2] = nil
;("BattleAttrTestView")[3] = nil
;("BattleAttrTestView")[4] = nil
;("BattleAttrTestView")[5] = nil
;("BattleAttrTestView")[6] = nil
;("BattleAttrTestView")[7] = nil
;("BattleAttrTestView")[8] = nil
;("BattleAttrTestView")[9] = nil
;("BattleAttrTestView")[10] = nil
;("BattleAttrTestView")[11] = nil
;("BattleAttrTestView")[12] = nil
;("BattleAttrTestView")[13] = nil
;("BattleAttrTestView")[14] = nil
;("BattleAttrTestView")[15] = nil
;("BattleAttrTestView")[16] = nil
;("BattleAttrTestView")[17] = nil
;("BattleAttrTestView")[18] = nil
;("BattleAttrTestView")[19] = nil
;("BattleAttrTestView")[20] = nil
;("BattleAttrTestView")[21] = nil
;("BattleAttrTestView")[22] = nil
;("BattleAttrTestView")[23] = nil
;("BattleAttrTestView")[24] = nil
;("BattleAttrTestView")[25] = nil
;("BattleAttrTestView")[26] = nil
local ("BattleAttrTestView")[27], attr2Edit = nil, "BattleAttrTestView"
function BattleAttrTestView:ctor()
	self.isHideCurrentSceneView = true
	self.Top_Size_Tile_Image_bg = SoraDGetChildByName(self, "Top_Size_Tile_Image_bg")
	self.ccs_node = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.ccs_node:setTitle(i18n("战斗属性测试界面"))
	self:init()
	self:createAttrEdit()
end
function BattleAttrTestView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_VIRTUAL_BUFF", handler(self, self.updateBuff))
end
function BattleAttrTestView:init()
	self.editParam, _ENV = nil, nil
	for _, v in ipairs(attr2Edit) do
		self.editParam[v.attr] = v.default or 0
	end
	SoraDGetCtrl("buffCtrl"):reqLastVirtualBuff()
end
function BattleAttrTestView:createAttrEdit()
	local button = ccui.Button:create()
	button:setPosition(160, display.height - 150)
	button:loadTextures("btn_green_small_01.png", "", "", ccui.TextureResType.plistType)
	button:setTitleText("设置")
	button:setName("send")
	button:setTitleFontSize(20)
	button:addTouchEventListener(function(btn, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			SoraDGetCtrl("buffCtrl"):reqUseVirtualBuff(self.editParam)
		end
	end)
	button:addTo(self, 99)
	local clearBtn = ccui.Button:create()
	clearBtn:setPosition(480, display.height - 150)
	clearBtn:loadTextures("btn_green_small_01.png", "", "", ccui.TextureResType.plistType)
	clearBtn:setTitleText("清除")
	clearBtn:setName("clear")
	clearBtn:setTitleFontSize(20)
	clearBtn:addTouchEventListener(function(btn, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			SoraDGetCtrl("buffCtrl"):reqUseVirtualBuff()
		end
	end)
	clearBtn:addTo(self, 99)
	self.scrollView = ccui.ScrollView:create()
	self.scrollView:setContentSize(cc.size(640, display.height - 200))
	self.scrollView:setBounceEnabled(true)
	self.scrollView:setDirection(cc.ui.UIScrollView.DIRECTION_VERTICAL)
	self.scrollView:setPosition(cc.p(0, 0))
	self.scrollView:addTo(self, 99)
	local vTotalHeight = 0
	local vTotalWidth = 588
	self.editCell, _ENV = self, self
	for k, v in ipairs(attr2Edit) do
		local subNode = self:createSubNode(v)
		if subNode then
			subNode:setPosition(cc.p(vTotalWidth / 2, vTotalHeight))
			subNode:addTo(self.scrollView)
			self.editCell[v.attr] = subNode
			vTotalHeight = vTotalHeight + 56
		else
			print("battleAttrNode not find")
		end
	end
	self.scrollView:setInnerContainerSize(cc.size(vTotalWidth, vTotalHeight))
end
function BattleAttrTestView:createSubNode(attrInfo)
	local baseNode = SoraDCreateCSBNode("battleAttrNode")
	local vecFunc = function(k, eventType, target)
		local v = target:getText()
		if v ~= nil then
			self.editParam[k] = tonumber(v) or 0
		end
	end
	SoraDGetChildByName(baseNode, "name"):setString(attrInfo.name)
	local vecX = SoraDGetChildByName(baseNode, "vecX")
	_ENV = nil
	;(nil).func = handlerEx(attrInfo.attr, vecFunc)
	;(nil).text = self.editParam[attrInfo.attr]
	vecX = SoraDChangeToEditBox(vecX, nil)
	vecX:setName("vecX")
	return baseNode
end
function BattleAttrTestView:updateBuff(target, data)
	local buff = data.buff
	for k, v in pairs(buff) do
		self.editParam[k] = v
		local cell = self.editCell[k]
		local vecX = SoraDGetChildByName(cell, "vecX")
		vecX:setString(tostring(v))
	end
end
return BattleAttrTestView
