local activity_9001737_Read = include("activity_9001737_Read")
local activity_9001737_Ctrl = SoraDGetCtrl("activity_9001737_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_mineInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001737/Com_mineInfo", Com_mineInfo)
function Com_mineInfo:onInit()
	self.fields.Button_rank:setTitle(i18n("sheepFeed_text_28"))
	self.fields.Button_rank:addClickListener(handler(self, self.onClick_Button_rank))
	self:fixChildrenPos()
end
function Com_mineInfo:onShow()
end
function Com_mineInfo:initData()
	self.myCamp = activity_9001737_Ctrl:getMyCamp()
	local campCfg = activity_9001737_Read.getCampCfgByCampType(self.myCamp)
	self.fields.icon:setURL(campCfg.campIcon)
	self.fields.Text_name:setString(i18n(campCfg.campName))
	local rank, myInfo = activity_9001737_Ctrl:getCampRankInfoByCamp(self.myCamp)
	activity_9001737_Ctrl = i18n(campCfg.campName)
	i18n(campCfg.campName).point = myInfo.point or 0
	self.fields.Text_myScore:setString(i18n("troublemaker_text_06", i18n(campCfg.campName)))
	activity_9001737_Ctrl = i18n("troublemaker_text_06", i18n(campCfg.campName))
	i18n("troublemaker_text_06", i18n(campCfg.campName)).rank = rank or 0
	self.fields.Text_rank:setString(i18n("troublemaker_text_05", i18n("troublemaker_text_06", i18n(campCfg.campName))))
	local enemyCamp = activity_9001737_Ctrl:getEnemyCamp()
	local enemyRank, enemyInfo = activity_9001737_Ctrl:getCampRankInfoByCamp(enemyCamp)
	activity_9001737_Ctrl = i18n("troublemaker_text_05", i18n("troublemaker_text_06", i18n(campCfg.campName)))
	i18n("troublemaker_text_05", i18n("troublemaker_text_06", i18n(campCfg.campName))).point = enemyInfo.point or 0
	self.fields.Text_enemyScore:setString(i18n("troublemaker_text_07", i18n("troublemaker_text_05", i18n("troublemaker_text_06", i18n(campCfg.campName)))))
	local diff, diffPoint = activity_9001737_Ctrl:getPointDiff()
	if diff then
		activity_9001737_Ctrl = i18n("troublemaker_text_07", i18n("troublemaker_text_05", i18n("troublemaker_text_06", i18n(campCfg.campName))))
		i18n("troublemaker_text_07", i18n("troublemaker_text_05", i18n("troublemaker_text_06", i18n(campCfg.campName)))).point = diffPoint or 0
		self.fields.Text_diff:setString(i18n("troublemaker_text_08", i18n("troublemaker_text_07", i18n("troublemaker_text_05", i18n("troublemaker_text_06", i18n(campCfg.campName))))))
	else
		activity_9001737_Ctrl = i18n("troublemaker_text_08", i18n("troublemaker_text_07", i18n("troublemaker_text_05", i18n("troublemaker_text_06", i18n(campCfg.campName)))))
		i18n("troublemaker_text_08", i18n("troublemaker_text_07", i18n("troublemaker_text_05", i18n("troublemaker_text_06", i18n(campCfg.campName))))).point = diffPoint or 0
		self.fields.Text_diff:setString(i18n("troublemaker_text_09", i18n("troublemaker_text_08", i18n("troublemaker_text_07", i18n("troublemaker_text_05", i18n("troublemaker_text_06", i18n(campCfg.campName)))))))
	end
end
function Com_mineInfo:onClick_Button_rank(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001737_Donate")
end
return Com_mineInfo
