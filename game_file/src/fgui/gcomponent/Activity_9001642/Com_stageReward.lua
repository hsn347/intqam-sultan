local activity_9001642_Read = include("activity_9001642_Read")
local activity_9001642_Ctrl = SoraDGetCtrl("activity_9001642_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_stageReward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001642/Com_stageReward", Com_stageReward)
function Com_stageReward:onInit()
	self.fields.mv_lg:setAllFrameName("activity_9001642_sweep_%.2d.png", 1)
	self.fields.mv_lg:setVisible(false)
	self.fields.List:setItemRenderer(handler(self, self.onRankRenderer))
end
function Com_stageReward:onRankRenderer(index, obj)
	obj:initData(self.cfg[index + 1], index + 1, self.isStage)
end
function Com_stageReward:onShow()
end
function Com_stageReward:initData(cfg, index, tag)
	self.isStage = tag == 2
	local phoenixType = activity_9001642_Ctrl:getPhoenixType()
	if self.isStage then
		self.fields.title:setString(activity_9001642_Read.getPhoneixStageName(index))
		self.fields.title:getChild("title"):setColor(phoenixType == index and cc.c3b(255, 212, 62) or cc.c3b(215, 195, 155))
		self.fields.mv_lg:setVisible(phoenixType == index)
	else
		activity_9001642_Ctrl = self.fields.mv_lg.setVisible
		self.fields.mv_lg.setVisible[1] = i18n("common_text_3049")
		local self.fields.mv_lg.setVisible[2], titleCfg = i18n("brightWar_title_02"), self.fields.mv_lg.setVisible
		self.fields.title:setString(titleCfg[index])
		self.fields.title:getChild("title"):setColor(cc.c3b(215, 195, 155))
		self.fields.mv_lg:setVisible(false)
	end
	self.cfg = cfg
	self.fields.List:setNumItems(#self.cfg)
	self.fields.List:setHeight(#self.cfg * 110)
	self:setHeight(#self.cfg * 110 + 50)
end
return Com_stageReward
