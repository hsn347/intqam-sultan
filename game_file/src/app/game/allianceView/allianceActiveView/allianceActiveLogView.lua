local gametop = gModuleMgr.getObject("gametop")
local allianceActiveltCtrl = include("allianceActiveltCtrl")
local allianceActiveCtrl = gametop.playertop_:getModule("allianceActiveCtrl")
local allianceActiveLogView = class("allianceActiveLogView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceActiveLogView")
	end
	return target
end)
function allianceActiveLogView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("alliance_text_44"))
	self.LoadingBar_bar = SoraDGetChildByName(self, "LoadingBar_bar")
	self.Text_percent = SoraDGetChildByName(self, "Text_percent")
	self.txtWarn = SoraDGetChildByName(self, "Text_warn")
	self.txtWarn:setString(i18n("common_text_1464"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("allianceActiveLogSingle")
	self:initData()
end
function allianceActiveLogView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_ACTIVE_TASK_UPDATE", handler(self, self.initData))
end
function allianceActiveLogView:initData()
	local list = allianceActiveCtrl:getCurPublishList()
	local allianceActiveCtrl, publishList = allianceActiveCtrl, allianceActiveCtrl
	for _, v in ipairs(list) do
		if v.name then
			table.insert(publishList, v)
		end
	end
	table.sort(publishList, function(a, b)
		if a.publishTime ~= b.publishTime then
			return b.publishTime < a.publishTime
		end
		return a.index < b.index
	end)
	allianceActiveCtrl = table.insert
	table.insert.scroll = self.scroll
	table.insert.view = self
	self.scroll:updateScrollView(cc.size(520, 200), publishList, 1, table.insert)
	self.txtWarn:setVisible(#publishList <= 0)
end
return allianceActiveLogView
