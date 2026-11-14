local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarStoreDetailView = class("epicWarStoreDetailView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicWarStoreDetailView")
	end
	return target
end)
function epicWarStoreDetailView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:hideTitle()
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_name:setString(i18n("epic_war_mystertyStore_name"))
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Text_des:setString(i18n("epic_war_mystertyStore_desc"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("epicWarStoreSingle")
end
function epicWarStoreDetailView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_UPDATE_STORE", handler(self, self.refreshData))
end
function epicWarStoreDetailView:refreshData(target, data)
	local pos = data.pos
	local newData = epicWarCtrl:getCurBoardInfoByPos(pos)
	self:initData(newData, pos)
end
function epicWarStoreDetailView:initData(data, pos)
	local shopList = data.eventData.eventParam.tacticsList
	for k, v in ipairs(shopList) do
		v.index = k
	end
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).pos = pos
	self.scroll:updateScrollView(cc.size(590, 120), shopList, 1, nil)
end
return epicWarStoreDetailView
