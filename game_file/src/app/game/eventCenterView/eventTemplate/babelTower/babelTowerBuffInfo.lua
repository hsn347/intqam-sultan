local babelTowerRead = gModuleMgr.sharedMgr("babelTowerRead")
local babelTowerCtrl = SoraDGetCtrl("babelTowerCtrl")
local babelTowerBuffInfo = class("babelTowerBuffInfo", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("babelTowerBuffInfo")
end)
function babelTowerBuffInfo:ctor(properties)
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.textTitle = SoraDGetChildByName(self.node, "Text_Title")
	self.textTitle:setString(i18n("Promise_Summit_text_02"))
	self.textTips = SoraDGetChildByName(self.node, "Text_Tips")
	self.textTips:setString(i18n("Promise_Summit_text_09"))
	self.scrollBuff = SoraDGetChildByName(self.node, "ScrollView")
	self.scrollBuff = include("commonAutoScrollList").new(self.scrollBuff)
	self.scrollBuff:setSingleCreate(handler(self, self.createSingleNode))
	self.scrollBuff:setSingleRefresh(handler(self, self.refreshSingleNode))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self.textNoBuff = SoraDGetChildByName(self.node, "Text_NoBuff")
	self.textNoBuff:setString(i18n("Promise_Summit_text_36"))
	self:initData()
end
function babelTowerBuffInfo:initData(target, data)
	self.buffList = babelTowerCtrl:getAllBuff()
	dump(self.buffList, "buffList", 10)
	if next(self.buffList) then
		self.textNoBuff:setVisible(false)
		self.scrollBuff:updateScrollView(cc.size(500, 70), self.buffList, 1)
	else
		self.textNoBuff:setVisible(true)
	end
end
function babelTowerBuffInfo:createSingleNode()
	local single = self.nodeSingle:clone()
	return single
end
function babelTowerBuffInfo:refreshSingleNode(parent, buffData)
	local spBg = SoraDGetChildByName(parent, "Sprite_Bg")
	local textDescribe = SoraDGetChildByName(parent, "Text_Describe")
	local spBuffNum = SoraDGetChildByName(parent, "Sprite_BuffNum")
	local spIcon = SoraDGetChildByName(parent, "Sprite_Icon")
	local textGetFloor = SoraDGetChildByName(parent, "Text_GetFloor")
	local panelInvalid = SoraDGetChildByName(parent, "Panel_InValid")
	_ENV = nil
	;(nil).num = buffData.floor
	textGetFloor:setString(i18n("Promise_Summit_text_42", nil))
	panelInvalid:setVisible(not buffData.isValid)
	local paramNum = buffData.buffType == 1 and buffData.buffValue - 1 or buffData.buffValue + 2
	print(string.format("frame_ttt_buffnum_0%d.png", paramNum), buffData.buffValue, paramNum)
	spBuffNum:setVisible(buffData.buffType ~= 2 and buffData.buffType ~= 4)
	local buffConfig = babelTowerRead:getBuffConfig(buffData.buffType)
	spIcon:setSpriteFrame(buffConfig.imgIcon)
	spBg:setSpriteFrame(buffConfig.imgLbg)
	spBuffNum:setSpriteFrame(string.format("frame_ttt_buffnum_0%d.png", paramNum))
	_ENV = string.format("frame_ttt_buffnum_0%d.png", paramNum)
	string.format("frame_ttt_buffnum_0%d.png", paramNum).level = buffData.buffType
	string.format("frame_ttt_buffnum_0%d.png", paramNum).num = buffData.buffValue
	textDescribe:setString(i18n(buffConfig.describe, string.format("frame_ttt_buffnum_0%d.png", paramNum)))
end
return babelTowerBuffInfo
