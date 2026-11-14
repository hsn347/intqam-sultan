local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local epicWarBuffView = class("epicWarBuffView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicWarBuffView")
	end
	return target
end)
function epicWarBuffView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("epic_war_soldierBless_name"))
	self.Text_none = SoraDGetChildByName(self, "Text_none")
	self.Text_none:setString(i18n("epic_war_soldierBless_desc02"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("epicWarBuffSingle")
	self.Node_tip = SoraDGetChildByName(self, "Node_tip")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("epic_war_bless_desc"))
	self:initData()
end
function epicWarBuffView:initData()
	local blessList = epicWarCtrl:getBlessList()
	if next(blessList) then
		local epicWarCtrl, blessArray = next(blessList), next(blessList)
		local index = 1
		local epicWarCtrl, joinID
		for k, v in ipairs(blessList) do
			if joinID[tostring(v)] then
				joinID[tostring(v)] = joinID[tostring(v)] + 1
				index = joinID[tostring(v)]
			else
				joinID[tostring(v)] = 1
				index = 1
			end
			epicWarCtrl = v
			v.index = index
			v.tacticsId = v
			v.quality = epicWarltCtrl.getBlessTacticsQuality(v)
			v.lv = epicWarCtrl:getBlessBuffMut(v, index)
			table.insert(blessArray, v)
		end
		table.sort(blessArray, function(a, b)
			if a.quality == b.quality then
				return a.tacticsId > b.tacticsId
			else
				return a.quality > b.quality
			end
		end)
		self.Text_none:setVisible(false)
		self.Node_tip:setVisible(true)
		self.scroll:updateScrollView(cc.size(536, 100), blessArray)
	else
		self.Text_none:setVisible(true)
		self.Node_tip:setVisible(false)
	end
end
return epicWarBuffView
