local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local pyramidWarltCtrl = include("pyramidWarltCtrl")
local alliancePBLPointInfoView = class("alliancePBLPointInfoView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("alliancePBLPointInfoView")
	end
	return target
end)
function alliancePBLPointInfoView:ctor()
	self.tableNode, _ENV = nil, nil
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.nodeBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeBg:setTitleName(i18n("pyramid_title_06"))
	self.nodeOwn = SoraDGetChildByName(self, "Node_own")
	self.labelRule = SoraDGetChildByName(self, "Text_rule")
	self.labelOwn = SoraDGetChildByName(self, "Text_own")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.tableNode[1] = SoraDGetChildByName(self, "Node_1")
	self.tableNode[2] = SoraDGetChildByName(self, "Node_2")
	self.tableNode[3] = SoraDGetChildByName(self, "Node_3")
	self.tableNode[4] = SoraDGetChildByName(self, "Node_4")
	self.labelRule:setString(i18n("pyramid_text_36"))
	self.labelDes:setString(i18n("pyramid_text_114"))
	self:initView()
end
function alliancePBLPointInfoView:initView()
	_ENV, _UPVALUE4_ = nil, nil
	;(nil).name = i18n("pyramid_btn_12")
	_ENV = nil
	;(nil).num = 4
	;(nil).win = i18n("pyramid_text_37", nil)
	_ENV = nil
	;(nil).num = 2
	_ENV, (nil).lose = i18n("pyramid_text_38", nil), i18n("pyramid_text_38", nil)
	i18n("pyramid_text_38", nil).name = i18n("pyramid_btn_13")
	_ENV = nil
	;(nil).num = 2
	i18n("pyramid_text_38", nil).win = i18n("pyramid_text_37", nil)
	_ENV = nil
	;(nil).num = 1
	_ENV, i18n("pyramid_text_38", nil).lose = i18n("pyramid_text_38", nil), i18n("pyramid_text_38", nil)
	i18n("pyramid_text_38", nil).name = i18n("pyramid_btn_14")
	_ENV = nil
	;(nil).num = 2
	i18n("pyramid_text_38", nil).win = i18n("pyramid_text_37", nil)
	_ENV = nil
	;(nil).num = 1
	_ENV, i18n("pyramid_text_38", nil).lose = i18n("pyramid_text_38", nil), i18n("pyramid_text_38", nil)
	i18n("pyramid_text_38", nil).name = i18n("pyramid_btn_15")
	_ENV = nil
	;(nil).num = 1
	i18n("pyramid_text_38", nil).win = i18n("pyramid_text_37", nil)
	_ENV = nil
	;(nil).num = 0
	i18n("pyramid_text_38", nil).lose = i18n("pyramid_text_38", nil)
	;(nil)[1] = nil
	;(nil)[2] = i18n("pyramid_text_38", nil)
	;(nil)[3] = i18n("pyramid_text_38", nil)
	local (nil)[4], data = i18n("pyramid_text_38", nil), nil
	for i, v in ipairs(self.tableNode) do
		SoraDGetChildByName(v, "Text_name"):setString(data[i].name)
		SoraDGetChildByName(v, "Text_lose"):setString(data[i].lose)
		SoraDGetChildByName(v, "Text_win"):setString(data[i].win)
	end
	local legion = pyramidWarCtrl:getOwnPBLLegion()
	local block = ""
	if legion then
		if 0 < legion.pinnacleCompetitionGroup then
			block = i18n("pyramid_text_39") .. pyramidWarltCtrl.getGroupName(legion.pinnacleCompetitionGroup)
		elseif 0 < legion.pinnacleArea then
			block = i18n("pyramid_text_39") .. pyramidWarltCtrl.getGroupName(legion.pinnacleBreakoutGroup)
		end
	end
	self.labelOwn:setString(block)
end
return alliancePBLPointInfoView
