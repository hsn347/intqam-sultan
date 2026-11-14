local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local epicWarTowerDetailView = class("epicWarTowerDetailView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicWarTowerDetailView")
	end
	return target
end)
function epicWarTowerDetailView:ctor()
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_name:setString(i18n("epic_war_arrowTower_name"))
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Button_destory = SoraDGetChildByName(self, "Button_destory")
	self.Button_destory:setTitleText(i18n("common_text_985"))
	self.Button_destory:addTouchEventListener(handler(self, self.btnDestoryCallBack))
end
function epicWarTowerDetailView:initData(data, pos)
	self.pos = pos
	local isExplored = epicWarCtrl:isTowerCanDestory(self.pos.x, self.pos.y)
	self.Button_destory:setVisible(isExplored)
	epicWarCtrl = nil
	;(nil).var1 = epicWarltCtrl.getTowerDamage()
	self.Text_des:setString(i18n("epic_war_arrowTower_desc", nil))
end
function epicWarTowerDetailView:btnDestoryCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		epicWarCtrl:sendReqTriggerEvent(self.pos)
		self:removeFromParent()
	end
end
return epicWarTowerDetailView
