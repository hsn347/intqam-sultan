local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local baseComponent = require("fgui.base.baseComponent")
local Com_PhoenixTaskSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameActivity/Com_PhoenixTaskSingle", Com_PhoenixTaskSingle)
function Com_PhoenixTaskSingle:onInit()
	self.reward, _ENV = nil, nil
	self.fields.Lab_done:setTitle(i18n("common_text_1892"))
	self.fields.Lab_done:setVisible(false)
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClick))
	self.fields.Button_go:setVisible(false)
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
end
function Com_PhoenixTaskSingle:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Com_PhoenixTaskSingle:onShow()
end
function Com_PhoenixTaskSingle:initData(data, taskType)
	self.data = data
	self.taskType = taskType
	_ENV = nil
	;(nil).val = fguiHelper.getColorString("#E2AF27", SoraDConvertNumberWithUnit(self.data.aim))
	self.fields.Text_des:setString(i18n(self.data.des, nil))
	self.reward = self.data.rewards
	self.fields.List_reward:setNumItems(#self.reward)
	self.fields.List_reward:setScrollEnable(#self.reward > 4)
	self.isCalimed = roaringFlameWarCtrl:isPhoenixTaskReceived(self.data.index)
	local isDone, progress = roaringFlameWarCtrl:isPhoenixTaskDone(self.data.index, self.taskType)
	self.isReward = not self.isCalimed and isDone
	if self.isCalimed or self.isReward then
		_ENV = i18n(self.data.des, nil)
		i18n(self.data.des, nil).count = SoraDConvertNumberWithUnit(self.data.aim)
		i18n(self.data.des, nil).total = SoraDConvertNumberWithUnit(self.data.aim)
		self.fields.Text_progress:setString(i18n("common_text_3683", i18n(self.data.des, nil)))
		self.fields.Text_progress:setColor(self.isCalimed and cc.c3b(215, 195, 155) or cc.c3b(109, 222, 0))
		self.fields.Lab_done:setVisible(self.isCalimed)
		self.fields.Button_go:setString(i18n("common_text_1146"))
		self.fields.Button_go:setVisible(not self.isCalimed)
	else
		self.fields.Lab_done:setVisible(false)
		self.fields.Button_go:setString(i18n("common_text_477"))
		self.fields.Button_go:setVisible(true)
		self.fields.Text_progress:setColor(cc.c3b(215, 195, 155))
		local count = fguiHelper.getColorString("#BE2828", SoraDConvertNumberWithUnit(progress or 0))
		_ENV = SoraDConvertNumberWithUnit(progress or 0)
		SoraDConvertNumberWithUnit(progress or 0).count = count
		SoraDConvertNumberWithUnit(progress or 0).total = SoraDConvertNumberWithUnit(self.data.aim)
		self.fields.Text_progress:setString(i18n("common_text_3683", SoraDConvertNumberWithUnit(progress or 0)))
	end
end
function Com_PhoenixTaskSingle:btnGoClick()
	SoraDPlaySound()
	if self.isReward then
		roaringFlameWarCtrl:reqCompletePhoenixTask(self.data.index)
	else
		if not worldMapDefine.isInRoaringFlame() then
			SoraDShowMsgTip(i18n("brightWar_text_79"))
			return
		end
		local subType = gWorldTypeServerDef.subTypeRoaringFlameWarPhoenix
		local ret = roaringFlameWarUtil.searchRoaringFlameWarBuild(subType, true)
		if not ret then
			SoraDShowMsgTip(i18n("flames_dunes_text123"))
			return
		else
			SoraDRemoveAllPanelFromManager()
		end
	end
end
return Com_PhoenixTaskSingle
