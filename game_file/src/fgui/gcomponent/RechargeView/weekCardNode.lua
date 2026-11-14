local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local weekCardNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/weekCardNode", weekCardNode)
function weekCardNode:onInit()
	self.itemList, _ENV = nil, nil
	self.fields.Com_tip:setTitle(i18n("common_text_2458"))
	self.fields.Com_tip:setHandle(handler(self, self.onBtnHelpCallBack))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_first:fixPos()
end
function weekCardNode:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1])
end
function weekCardNode:onShow()
end
function weekCardNode:initData()
	if not rechargeActivityCtrl:getWeekActivityList() then
		rechargeActivityCtrl = rechargeActivityCtrl:getWeekActivityList()
	end
	self.monthData = rechargeActivityCtrl:getWeekActivityList()
	if self.monthData then
		self.monthData.isGot, rechargeActivityCtrl, self.monthData.isRenew, rechargeActivityCtrl, self.monthData.canGet, rechargeActivityCtrl, self.monthData.onSale, rechargeActivityCtrl, rechargeActivityCtrl = rechargeActivityCtrl, rechargeActivityCtrl, rechargeActivityCtrl, rechargeActivityCtrl, rechargeActivityCtrl, rechargeActivityCtrl, rechargeActivityCtrl, rechargeActivityCtrl, self.monthData
		local sortTbl = self.monthData
		local keys = table.keys(self.monthData)
		if next(keys) then
			table.sort(keys, function(l, r)
				return l < r
			end)
		end
		for i, v in ipairs(keys) do
			local val = self.monthData[v]
			if val.isbuy then
				if val.isdayget then
					if val.canRenew then
						table.insert(sortTbl.isRenew, val)
					else
						table.insert(sortTbl.isGot, val)
					end
				else
					table.insert(sortTbl.canGet, val)
				end
			else
				table.insert(sortTbl.onSale, val)
			end
		end
		local loop2Insert = function(tbl)
			local _ENV, reTbl
			for i, v in ipairs(tbl) do
				if next(v) then
					for index, value in ipairs(v) do
						table.insert(reTbl, value)
					end
				end
			end
			return reTbl
		end
		for _, v in ipairs(sortTbl.onSale) do
			local lvLimit = SoraDStringSplit(v.lvLimit, ",")
			v.sortLvLimit = tonumber(lvLimit[1]) or 0
		end
		table.sort(sortTbl.onSale, function(a, b)
			if a.sortLvLimit == b.sortLvLimit then
				return a.ID < b.ID
			else
				return a.sortLvLimit > b.sortLvLimit
			end
		end)
		_UPVALUE4_ = sortTbl.onSale
		sortTbl.onSale[1] = sortTbl.canGet
		sortTbl.onSale[2] = sortTbl.onSale
		sortTbl.onSale[3] = sortTbl.isRenew
		sortTbl.onSale[4] = sortTbl.isGot
		local finalMonthTbl = loop2Insert(sortTbl.onSale)
		self.itemList = finalMonthTbl
		self.fields.List:setNumItems(#self.itemList)
	end
end
function weekCardNode:onBtnHelpCallBack()
	_ENV = "common_text_4177"
	;("common_text_4177").align = SoraDFLabelR()
	SoraDShowHelpMsgTip(i18n("common_text_4177"), "common_text_4177")
end
return weekCardNode
