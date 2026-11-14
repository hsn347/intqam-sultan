local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_listBox = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameActivity/Com_listBox", Com_listBox)
function Com_listBox:onInit()
	self.fields.mv_top:setAllFrameName("dh_lzjnan_%.2d.png", 1)
	self.fields.mv_bottom:setAllFrameName("dh_lzjnan_%.2d.png", 1)
end
function Com_listBox:onShow()
	local roaringFlameWarRead, stageData
	self.stageConfig = roaringFlameWarRead.getTurntableStageCfg()
	for k, cfg in ipairs(self.stageConfig) do
		roaringFlameWarRead = nil
		;(nil).stage = k
		;(nil).point = cfg.Value
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		;(nil).rewards = serviceFunctions.tableFormat(cfg.rewards, nil)
		table.insert(stageData, nil)
	end
	self.stageData = stageData
	roaringFlameWarRead = ipairs(self.stageConfig)
	ipairs(self.stageConfig).activityID = gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY
	ipairs(self.stageConfig).stageMax = #self.stageData
	self.fields.Com_boxList:initData(ipairs(self.stageConfig))
end
function Com_listBox:initData()
	local data = roaringFlameWarCtrl:getTurntableData()
	local times = data.times or 0
	for i, data in ipairs(self.stageData) do
		data.state = roaringFlameWarCtrl:getStageBoxStatues(self.stageConfig[i].position, self.stageConfig[i].Value)
	end
	roaringFlameWarCtrl = ipairs(self.stageData)
	ipairs(self.stageData).score = times
	ipairs(self.stageData).stageData = self.stageData
	self.fields.Com_boxList:updateData(ipairs(self.stageData))
	roaringFlameWarCtrl = nil
	;(nil).num = times
	self.fields.Text_score:setString(i18n("Bubble_Bobble_text_02", nil))
end
return Com_listBox
