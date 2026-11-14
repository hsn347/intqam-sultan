local CtOptimizeScroll = class("ctOptimizeScroll", function(target)
	return target
end)
function CtOptimizeScroll:ctor()
end
function CtOptimizeScroll.format2MyList(list)
	local _ENV, retTbl
	for _, v in ipairs(list) do
		_ENV = nil
		;(nil).data = v
		table.insert(retTbl, nil)
	end
	return retTbl
end
function CtOptimizeScroll:init(options)
	self.cols = options.clos or 1
	self.singleSize = options.singleSize
	self.otherH = options.otherH or 0
	self.otherIndex = options.otherIndex
	self.editSingle = options.editHandl
	self.createSingle = options.addHandl
	self.reCreateSingle = options.reInitHandl
	self.sortFun = options.sortHandl
	self.findFun = options.findHandl
	if not options.list then
		_UPVALUE0_ = options.list
	end
	self.canUseOCXs, _UPVALUE0_, self.myDataList = self.format2MyList(options.list), self.format2MyList(options.list), self.format2MyList(options.list)
	self.otherSinglePosY = -10
end
function CtOptimizeScroll:removeAllSingle()
	local passVisible = false
	for i, v in ipairs(self.myDataList) do
		if v.point then
			v.point:removeFromParent()
			v.point = nil
			passVisible = true
		elseif passVisible then
			break
		end
	end
	for i, v in ipairs(self.canUseOCXs) do
		v:removeFromParent()
	end
	self.canUseOCXs, _ENV = ipairs(self.canUseOCXs)
end
function CtOptimizeScroll:getAllSingle()
	local _ENV, ret
	local passVisible = false
	for i, v in ipairs(self.myDataList) do
		if v.point then
			table.insert(ret, v.point)
			passVisible = true
		elseif passVisible then
			break
		end
	end
	for i, v in ipairs(self.canUseOCXs) do
		table.insert(ret, v)
	end
	return ret
end
function CtOptimizeScroll:getOtherSinglePosY()
	return self.otherSinglePosY
end
function CtOptimizeScroll:begin2Run()
	self:removeAllSingle()
	self:refreshTable()
	if not self.initScrollCallBack then
		self:addEventListener(handler(self, self.scrollEventCallBack))
		function self.addEventListener(target, cb)
			target.scrollEventCb = cb
		end
		self.initScrollCallBack = true
	end
	self:updateScroll()
end
function CtOptimizeScroll:setNewTable(newList)
