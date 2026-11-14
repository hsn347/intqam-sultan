local CrazyIntegralExplainView = class("crazyIntegralExplainView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("crazyIntegralExplainView")
	end
	return target
end)
function CrazyIntegralExplainView:ctor()
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.itemCopy = SoraDGetChildByName(self, "Image_item")
	self:initData()
end
function CrazyIntegralExplainView:initData(...)
	local gametop = gModuleMgr.getObject("gametop")
	local newActivityCtrl = gametop.playertop_:getModule("newActivityCtrl")
	self.listTbl = newActivityCtrl:getCrazyScoreConfig()
	self:initView()
end
function CrazyIntegralExplainView:initView(...)
	local newActivityRead = include("newActivityRead")
	local desTbl = newActivityRead.getCrazyScoreDes()
	local editSingle = function(ocx, info, showSheer)
		local howText = ""
		if gPersonLimitedTimeType.TRAIN_SOLDIERS == info.eventType then
			_ENV = nil
			;(nil).lv = info.condition
			howText = i18n(desTbl[info.eventType].des, nil)
		elseif gPersonLimitedTimeType.TECHNOLOGY_POWER == info.eventType then
			_ENV = nil
			;(nil).num = info.condition
			howText = i18n(desTbl[info.eventType].des, nil)
		elseif gPersonLimitedTimeType.BUILDDING_POWER == info.eventType then
			_ENV = nil
			;(nil).num = info.condition
			howText = i18n(desTbl[info.eventType].des, nil)
		elseif gPersonLimitedTimeType.COLLECT_RESOURCE == info.eventType then
			local resDesRead = include("resDesRead")
			local resName = resDesRead.getName(info.condition)
			_ENV = nil
			;(nil).res = resName
			howText = i18n(desTbl[info.eventType].des, nil)
		elseif gPersonLimitedTimeType.EVERY_LOGIN == info.eventType then
			_ENV = i18n(desTbl[info.eventType].des, nil)
			i18n(desTbl[info.eventType].des, nil).num = info.condition
			howText = i18n(desTbl[info.eventType].des, (i18n(desTbl[info.eventType].des, nil)))
		end
		ocx:getChildByName("Text_how"):setString(howText)
		_ENV = nil
		;(nil).point = info.point
		ocx:getChildByName("Text_point"):setString(i18n("common_text_2200", nil))
		ocx:getChildByName("Image_sheer"):setVisible(showSheer)
	end
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, #self.listTbl * 50)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(self.listTbl) do
		local single = self.itemCopy:clone()
		editSingle(single, v, i % 2 == 1)
		single:addTo(self.scroll)
		single:setPosition(sSize.width / 2, sH - (i - 1) * 50)
	end
	self.txtTitle:setString(i18n("common_text_3047"))
end
return CrazyIntegralExplainView
