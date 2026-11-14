local baseComponent = require("fgui.base.baseComponent")
local Activity_9001630_single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001630/Activity_9001630_single", Activity_9001630_single)
function Activity_9001630_single:onInit()
	self.fields.list_rewards:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.list_rewards2:setItemRenderer(handler(self, self.onItemRederer))
	_ENV, _ENV = self.fields.list_rewards2, self.fields.list_rewards2.setItemRenderer
	self.fields.list_rewards2.title = "starlight_name_01"
	_ENV, self.fields.list_rewards2.setItemRenderer[0], self.fields.list_rewards2.des = self.fields.list_rewards2, self.fields.list_rewards2, i18n("magic_flip_6")
	self.fields.list_rewards2.title = "starlight_name_02"
	_ENV = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).num = 3
	_ENV, self.fields.list_rewards2.setItemRenderer[1], self.fields.list_rewards2.des = self.fields.list_rewards2, self.fields.list_rewards2, i18n("magic_flip_6", handler(self, self.onItemRederer))
	self.fields.list_rewards2.title = "starlight_name_03"
	_ENV = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).num = 2
	_ENV, self.fields.list_rewards2.setItemRenderer[2], self.fields.list_rewards2.des = self.fields.list_rewards2, self.fields.list_rewards2, i18n("magic_flip_6", handler(self, self.onItemRederer))
	self.fields.list_rewards2.title = "starlight_name_04"
	_ENV, self.fields.list_rewards2.setItemRenderer[3], self.fields.list_rewards2.des = self.fields.list_rewards2, self.fields.list_rewards2, i18n("magic_flip_7")
	self.fields.list_rewards2.title = "nebula_paradise_text_06"
	self.config, self.fields.list_rewards2.setItemRenderer[4], self.fields.list_rewards2.des = self.fields.list_rewards2.setItemRenderer, self.fields.list_rewards2, i18n("magic_flip_7")
end
function Activity_9001630_single:onShow()
end
function Activity_9001630_single:initData(cfg, lastCfg)
	self.rewardList = cfg.reward
	if cfg.rewardType == 1 then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.list_rewards:setNumItems(#self.rewardList)
	else
		self.fields.list_rewards2:setNumItems(#self.rewardList)
		if lastCfg and lastCfg.rewardType == cfg.rewardType then
			self.controllers.c1:setSelectedIndex(2)
		else
			self.controllers.c1:setSelectedIndex(1)
			self.fields.Text_des:setString(self.config[cfg.rewardType].des)
			dump(self.config[cfg.rewardType], "self.config[cfg.rewardType]")
			self.fields.Text_title_normal:setString(i18n(self.config[cfg.rewardType].title))
		end
	end
end
function Activity_9001630_single:onItemRederer(index, target)
	target:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
end
return Activity_9001630_single
