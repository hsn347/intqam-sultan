local baseComponent = require("fgui.base.baseComponent")
local watchTowerSoulSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWatchTower/watchTowerSoulSingle", watchTowerSoulSingle)
function watchTowerSoulSingle:onInit()
	self.fields.Text_aim:setString(i18n("common_text_008"))
	self.fields.Text_title:setTimeUpdateListener(handler(self, self.timerUpdate))
	self.fields.Bar:hideTitle()
	self.fields.Text_targetPos:setTouchEnabled(true)
	self.fields.Text_targetPos:addClickListener(handler(self, self.btnGoPosClick))
	self:fixChildrenPos()
	self.fields.arrow:setRotation(SoraDFIsRA() and 90 or -90)
	self:addClickListener(handler(self, self.singleClick))
end
function watchTowerSoulSingle:onShow()
end
function watchTowerSoulSingle:initData(queueObj)
	self.myQueueObj = queueObj
	self:initView()
end
function watchTowerSoulSingle:initView()
	self:fillBaseInfo()
	self.fields.Text_title:beginTime(self.myQueueObj:getStatusRemainTime())
	self.fields.Bar:setMax(self.myQueueObj:getTotalMoveTime())
end
function watchTowerSoulSingle:timerUpdate(time)
	self.fields.Bar:setValue(time)
end
function watchTowerSoulSingle:fillBaseInfo()
	self.fields.Text_name:setString(i18n("common_text_1222"))
	self.fields.Image_head:setSpriteFrame("roman_full.png")
	local toData = self.myQueueObj:getTo()
	if toData then
		self.fields.Text_target:setVisible(true)
		self.fields.Text_targetPos:setVisible(true)
		_ENV = i18n("common_text_1222")
		i18n("common_text_1222").x = toData.x
		i18n("common_text_1222").y = toData.y
		_ENV = "common_text_2155"
		;("common_text_2155").u = true
		self.fields.Text_targetPos:setString(SoraDWrapHtmlTagByStyle(i18n("common_text_2155", i18n("common_text_1222")), "common_text_2155"))
		if toData.mapType then
			self.fields.Text_target:setString(include("mapObjUtil").reOutDoor(toData))
		end
	else
		self.fields.Text_target:setVisible(false)
		self.fields.Text_targetPos:setVisible(false)
	end
end
function watchTowerSoulSingle:btnGoPosClick(panel, eventType)
	SoraDPlaySound()
	local toData = self.myQueueObj:getTo()
	if toData then
		SoraDGotoWorldMapPoint(cc.p(toData.x, toData.y), true)
		SoraDRemoveAllPanelFromManager()
	end
end
function watchTowerSoulSingle:singleClick()
	SoraDPlaySound()
	local panel = uiManager:show("WatchTowerDetailView")
	panel.view:afterInitData(self.myQueueObj)
end
return watchTowerSoulSingle
