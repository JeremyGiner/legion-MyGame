(function (console, $global) { "use strict";
var $hxClasses = {},$estr = function() { return js_Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
$hxClasses["EReg"] = EReg;
EReg.__name__ = ["EReg"];
EReg.prototype = {
	match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,matched: function(n) {
		if(this.r.m != null && n >= 0 && n < this.r.m.length) return this.r.m[n]; else throw new js__$Boot_HaxeError("EReg::matched");
	}
	,__class__: EReg
};
var HxOverrides = function() { };
$hxClasses["HxOverrides"] = HxOverrides;
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.strDate = function(s) {
	var _g = s.length;
	switch(_g) {
	case 8:
		var k = s.split(":");
		var d = new Date();
		d.setTime(0);
		d.setUTCHours(k[0]);
		d.setUTCMinutes(k[1]);
		d.setUTCSeconds(k[2]);
		return d;
	case 10:
		var k1 = s.split("-");
		return new Date(k1[0],k1[1] - 1,k1[2],0,0,0);
	case 19:
		var k2 = s.split(" ");
		var y = k2[0].split("-");
		var t = k2[1].split(":");
		return new Date(y[0],y[1] - 1,y[2],t[0],t[1],t[2]);
	default:
		throw new js__$Boot_HaxeError("Invalid date format : " + s);
	}
};
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) i = 0;
	}
	while(i < len) {
		if(a[i] === obj) return i;
		i++;
	}
	return -1;
};
HxOverrides.remove = function(a,obj) {
	var i = HxOverrides.indexOf(a,obj,0);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var List = function() {
	this.length = 0;
};
$hxClasses["List"] = List;
List.__name__ = ["List"];
List.prototype = {
	add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,push: function(item) {
		var x = [item,this.h];
		this.h = x;
		if(this.q == null) this.q = x;
		this.length++;
	}
	,first: function() {
		if(this.h == null) return null; else return this.h[0];
	}
	,pop: function() {
		if(this.h == null) return null;
		var x = this.h[0];
		this.h = this.h[1];
		if(this.h == null) this.q = null;
		this.length--;
		return x;
	}
	,isEmpty: function() {
		return this.h == null;
	}
	,clear: function() {
		this.h = null;
		this.q = null;
		this.length = 0;
	}
	,remove: function(v) {
		var prev = null;
		var l = this.h;
		while(l != null) {
			if(l[0] == v) {
				if(prev == null) this.h = l[1]; else prev[1] = l[1];
				if(this.q == l) this.q = prev;
				this.length--;
				return true;
			}
			prev = l;
			l = l[1];
		}
		return false;
	}
	,iterator: function() {
		return new _$List_ListIterator(this.h);
	}
	,__class__: List
};
var _$List_ListIterator = function(head) {
	this.head = head;
	this.val = null;
};
$hxClasses["_List.ListIterator"] = _$List_ListIterator;
_$List_ListIterator.__name__ = ["_List","ListIterator"];
_$List_ListIterator.prototype = {
	hasNext: function() {
		return this.head != null;
	}
	,next: function() {
		this.val = this.head[0];
		this.head = this.head[1];
		return this.val;
	}
	,__class__: _$List_ListIterator
};
Math.__name__ = ["Math"];
var Reflect = function() { };
$hxClasses["Reflect"] = Reflect;
Reflect.__name__ = ["Reflect"];
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		if (e instanceof js__$Boot_HaxeError) e = e.val;
		return null;
	}
};
Reflect.setField = function(o,field,value) {
	o[field] = value;
};
Reflect.getProperty = function(o,field) {
	var tmp;
	if(o == null) return null; else if(o.__properties__ && (tmp = o.__properties__["get_" + field])) return o[tmp](); else return o[field];
};
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
};
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && !(f.__name__ || f.__ename__);
};
Reflect.deleteField = function(o,field) {
	if(!Object.prototype.hasOwnProperty.call(o,field)) return false;
	delete(o[field]);
	return true;
};
var Std = function() { };
$hxClasses["Std"] = Std;
Std.__name__ = ["Std"];
Std["is"] = function(v,t) {
	return js_Boot.__instanceof(v,t);
};
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std["int"] = function(x) {
	return x | 0;
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
Std.parseFloat = function(x) {
	return parseFloat(x);
};
var StringBuf = function() {
	this.b = "";
};
$hxClasses["StringBuf"] = StringBuf;
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	add: function(x) {
		this.b += Std.string(x);
	}
	,__class__: StringBuf
};
var StringTools = function() { };
$hxClasses["StringTools"] = StringTools;
StringTools.__name__ = ["StringTools"];
StringTools.hex = function(n,digits) {
	var s = "";
	var hexChars = "0123456789ABCDEF";
	do {
		s = hexChars.charAt(n & 15) + s;
		n >>>= 4;
	} while(n > 0);
	if(digits != null) while(s.length < digits) s = "0" + s;
	return s;
};
StringTools.fastCodeAt = function(s,index) {
	return s.charCodeAt(index);
};
var ValueType = $hxClasses["ValueType"] = { __ename__ : ["ValueType"], __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] };
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; };
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; };
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
var Type = function() { };
$hxClasses["Type"] = Type;
Type.__name__ = ["Type"];
Type.getClass = function(o) {
	if(o == null) return null; else return js_Boot.getClass(o);
};
Type.getClassName = function(c) {
	var a = c.__name__;
	if(a == null) return null;
	return a.join(".");
};
Type.getEnumName = function(e) {
	var a = e.__ename__;
	return a.join(".");
};
Type.resolveClass = function(name) {
	var cl = $hxClasses[name];
	if(cl == null || !cl.__name__) return null;
	return cl;
};
Type.resolveEnum = function(name) {
	var e = $hxClasses[name];
	if(e == null || !e.__ename__) return null;
	return e;
};
Type.createInstance = function(cl,args) {
	var _g = args.length;
	switch(_g) {
	case 0:
		return new cl();
	case 1:
		return new cl(args[0]);
	case 2:
		return new cl(args[0],args[1]);
	case 3:
		return new cl(args[0],args[1],args[2]);
	case 4:
		return new cl(args[0],args[1],args[2],args[3]);
	case 5:
		return new cl(args[0],args[1],args[2],args[3],args[4]);
	case 6:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5]);
	case 7:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
	case 8:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
	default:
		throw new js__$Boot_HaxeError("Too many arguments");
	}
	return null;
};
Type.createEmptyInstance = function(cl) {
	function empty() {}; empty.prototype = cl.prototype;
	return new empty();
};
Type.createEnum = function(e,constr,params) {
	var f = Reflect.field(e,constr);
	if(f == null) throw new js__$Boot_HaxeError("No such constructor " + constr);
	if(Reflect.isFunction(f)) {
		if(params == null) throw new js__$Boot_HaxeError("Constructor " + constr + " need parameters");
		return Reflect.callMethod(e,f,params);
	}
	if(params != null && params.length != 0) throw new js__$Boot_HaxeError("Constructor " + constr + " does not need parameters");
	return f;
};
Type.getEnumConstructs = function(e) {
	var a = e.__constructs__;
	return a.slice();
};
Type["typeof"] = function(v) {
	var _g = typeof(v);
	switch(_g) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = js_Boot.getClass(v);
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ || v.__ename__) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
};
var cloner_Cloner = function() {
	this.stringMapCloner = new cloner_MapCloner(this,haxe_ds_StringMap);
	this.intMapCloner = new cloner_MapCloner(this,haxe_ds_IntMap);
	this.classHandles = new haxe_ds_StringMap();
	this.classHandles.set("String",$bind(this,this.returnString));
	this.classHandles.set("Array",$bind(this,this.cloneArray));
	this.classHandles.set("haxe.ds.StringMap",($_=this.stringMapCloner,$bind($_,$_.clone)));
	this.classHandles.set("haxe.ds.IntMap",($_=this.intMapCloner,$bind($_,$_.clone)));
};
$hxClasses["cloner.Cloner"] = cloner_Cloner;
cloner_Cloner.__name__ = ["cloner","Cloner"];
cloner_Cloner.STclone = function(v) {
	return new cloner_Cloner().clone(v);
};
cloner_Cloner.prototype = {
	returnString: function(v) {
		return v;
	}
	,clone: function(v) {
		this.cache = new haxe_ds_ObjectMap();
		var outcome = this._clone(v);
		this.cache = null;
		return outcome;
	}
	,_clone: function(v) {
		if(typeof(v) == "string") return v;
		{
			var _g = Type["typeof"](v);
			switch(_g[1]) {
			case 0:
				return null;
			case 1:
				return v;
			case 2:
				return v;
			case 3:
				return v;
			case 4:
				if(!(this.cache.h.__keys__[v.__id__] != null)) return this.handleAnonymous(v);
				return this.cache.h[v.__id__];
			case 5:
				return null;
			case 6:
				var c = _g[2];
				if(!(this.cache.h.__keys__[v.__id__] != null)) this.cache.set(v,this.handleClass(c,v));
				return this.cache.h[v.__id__];
			case 7:
				var e = _g[2];
				return v;
			case 8:
				return null;
			}
		}
	}
	,handleAnonymous: function(v) {
		var properties = Reflect.fields(v);
		var anonymous = { };
		this.cache.set(v,anonymous);
		var _g1 = 0;
		var _g = properties.length;
		while(_g1 < _g) {
			var i = _g1++;
			var property = properties[i];
			Reflect.setField(anonymous,property,this._clone(Reflect.getProperty(v,property)));
		}
		return anonymous;
	}
	,handleClass: function(c,inValue) {
		var handle;
		var key = Type.getClassName(c);
		handle = this.classHandles.get(key);
		if(handle == null) handle = $bind(this,this.cloneClass);
		return handle(inValue);
	}
	,cloneArray: function(inValue) {
		var array = inValue.slice();
		var _g1 = 0;
		var _g = array.length;
		while(_g1 < _g) {
			var i = _g1++;
			array[i] = this._clone(array[i]);
		}
		return array;
	}
	,cloneClass: function(inValue) {
		var outValue = Type.createEmptyInstance(inValue == null?null:js_Boot.getClass(inValue));
		this.cache.set(inValue,outValue);
		var fields = Reflect.fields(inValue);
		var _g1 = 0;
		var _g = fields.length;
		while(_g1 < _g) {
			var i = _g1++;
			var field = fields[i];
			var property = Reflect.getProperty(inValue,field);
			Reflect.setField(outValue,field,this._clone(property));
		}
		return outValue;
	}
	,__class__: cloner_Cloner
};
var cloner_MapCloner = function(cloner1,type) {
	this.cloner = cloner1;
	this.type = type;
	this.noArgs = [];
};
$hxClasses["cloner.MapCloner"] = cloner_MapCloner;
cloner_MapCloner.__name__ = ["cloner","MapCloner"];
cloner_MapCloner.prototype = {
	clone: function(inValue) {
		var inMap = inValue;
		var map = Type.createInstance(this.type,this.noArgs);
		var $it0 = inMap.keys();
		while( $it0.hasNext() ) {
			var key = $it0.next();
			map.set(key,this.cloner._clone(inMap.get(key)));
		}
		return map;
	}
	,__class__: cloner_MapCloner
};
var collider_CollisionCheckerPost = function() { };
$hxClasses["collider.CollisionCheckerPost"] = collider_CollisionCheckerPost;
collider_CollisionCheckerPost.__name__ = ["collider","CollisionCheckerPost"];
collider_CollisionCheckerPost.check = function(oShapeA,oShapeB) {
	var res = collider_CollisionCheckerPost._check(oShapeA,oShapeB);
	if(res != null) return res;
	res = collider_CollisionCheckerPost._check(oShapeB,oShapeA);
	if(res != null) return res;
	throw new js__$Boot_HaxeError("[ERROR]:Collision check:Unable to determine collision between thoses class of shape : " + Type.getClassName(Type.getClass(oShapeA)) + "; " + Type.getClassName(Type.getClass(oShapeB)));
	return null;
};
collider_CollisionCheckerPost._check = function(oShapeA,oShapeB) {
	if(js_Boot.__instanceof(oShapeA,space_IAlignedAxisBox)) {
		if(js_Boot.__instanceof(oShapeB,space_IAlignedAxisBox)) return collider_CollisionCheckerPost._AAB_check(oShapeA,oShapeB);
		if(js_Boot.__instanceof(oShapeB,space_Circle)) throw new js__$Boot_HaxeError("not implemented");
	}
	if(js_Boot.__instanceof(oShapeA,space_Circle)) {
		if(js_Boot.__instanceof(oShapeB,space_Vector3)) return collider_CollisionCheckerPost.circlePoint_check(oShapeA,oShapeB);
	}
	if(js_Boot.__instanceof(oShapeB,space_Circle)) return collider_CollisionCheckerPost.collisionCircleCircle(oShapeA,oShapeB);
	return null;
};
collider_CollisionCheckerPost.collisionCircleCircle = function(oCircleA,oCircleB) {
	var fDelta = space_Vector3.distance(oCircleA.position_get(),oCircleB.position_get());
	if(fDelta <= oCircleA.radius_get() + oCircleB.radius_get()) return true; else return false;
};
collider_CollisionCheckerPost.circlePoint_check = function(oCircle,oPoint) {
	var fDelta = space_Vector3.distance(oCircle.position_get(),oPoint);
	if(fDelta <= oCircle.radius_get()) return true; else return false;
};
collider_CollisionCheckerPost._AAB_check = function(oBoxA,oBoxB) {
	if(collider_CollisionCheckerPost.axisCollision_get(oBoxA.left_get(),oBoxA.right_get(),oBoxB.left_get(),oBoxB.right_get()) < 0) return false;
	if(collider_CollisionCheckerPost.axisCollision_get(oBoxA.bottom_get(),oBoxA.top_get(),oBoxB.bottom_get(),oBoxB.top_get()) < 0) return false;
	return true;
};
collider_CollisionCheckerPost.axisCollision_get = function(a1,a2,b1,b2) {
	return Math.min(a2,b2) - Math.max(a1,b1);
};
collider_CollisionCheckerPost.axisCollision2_get = function(a1,a2,b1,b2) {
	return Math.max(a2,b2) - Math.min(a1,b1) <= a2 - a1 + (b2 - b1);
};
var collider_CollisionCheckerPostInt = function() { };
$hxClasses["collider.CollisionCheckerPostInt"] = collider_CollisionCheckerPostInt;
collider_CollisionCheckerPostInt.__name__ = ["collider","CollisionCheckerPostInt"];
collider_CollisionCheckerPostInt.check = function(oShapeA,oShapeB) {
	var res = collider_CollisionCheckerPostInt._check(oShapeA,oShapeB);
	if(res != null) return res;
	res = collider_CollisionCheckerPostInt._check(oShapeB,oShapeA);
	if(res != null) return res;
	throw new js__$Boot_HaxeError("[ERROR]:Collision check:Unable to determine collision between thoses class of shape : " + Type.getClassName(Type.getClass(oShapeA)) + "; " + Type.getClassName(Type.getClass(oShapeB)));
	return null;
};
collider_CollisionCheckerPostInt._check = function(oShapeA,oShapeB) {
	if(js_Boot.__instanceof(oShapeA,space_IAlignedAxisBoxi)) {
		if(js_Boot.__instanceof(oShapeB,space_IAlignedAxisBoxi)) return collider_CollisionCheckerPostInt._AAB_check(oShapeA,oShapeB);
		if(js_Boot.__instanceof(oShapeB,space_Circlei)) throw new js__$Boot_HaxeError("not implemented");
	}
	if(js_Boot.__instanceof(oShapeA,space_Circlei)) {
		if(js_Boot.__instanceof(oShapeB,space_Vector2i)) return collider_CollisionCheckerPostInt.CircleiPoint_check(oShapeA,oShapeB);
	}
	if(js_Boot.__instanceof(oShapeB,space_Circlei)) return collider_CollisionCheckerPostInt.collisionCircleiCirclei(oShapeA,oShapeB);
	return null;
};
collider_CollisionCheckerPostInt.collisionCircleiCirclei = function(oCircleiA,oCircleiB) {
	var fDelta = space_Vector2i.distance(oCircleiA.position_get(),oCircleiB.position_get());
	if(fDelta <= oCircleiA.radius_get() + oCircleiB.radius_get()) return true; else return false;
};
collider_CollisionCheckerPostInt.CircleiPoint_check = function(oCirclei,oPoint) {
	var fDelta = space_Vector2i.distance(oCirclei.position_get(),oPoint);
	if(fDelta <= oCirclei.radius_get()) return true; else return false;
};
collider_CollisionCheckerPostInt._AAB_check = function(oBoxA,oBoxB) {
	if(collider_CollisionCheckerPost.axisCollision_get(oBoxA.left_get(),oBoxA.right_get(),oBoxB.left_get(),oBoxB.right_get()) < 0) return false;
	if(collider_CollisionCheckerPost.axisCollision_get(oBoxA.bottom_get(),oBoxA.top_get(),oBoxB.bottom_get(),oBoxB.top_get()) < 0) return false;
	return true;
};
collider_CollisionCheckerPostInt.axisCollision_get = function(a1,a2,b1,b2) {
	return utils_IntTool.min(a2,b2) - utils_IntTool.max(a1,b1);
};
collider_CollisionCheckerPostInt.axisCollision2_get = function(a1,a2,b1,b2) {
	return Math.max(a2,b2) - Math.min(a1,b1) <= a2 - a1 + (b2 - b1);
};
var collider_CollisionCheckerPriorInt = function() { };
$hxClasses["collider.CollisionCheckerPriorInt"] = collider_CollisionCheckerPriorInt;
collider_CollisionCheckerPriorInt.__name__ = ["collider","CollisionCheckerPriorInt"];
collider_CollisionCheckerPriorInt.check = function(oShape1,oVelocity1,oShape2,oVelocity2) {
	var res = collider_CollisionCheckerPriorInt._check(oShape1,oVelocity1,oShape2,oVelocity2);
	if(res != null) return res(oShape1,oVelocity1,oShape2,oVelocity2);
	res = collider_CollisionCheckerPriorInt._check(oShape2,oVelocity2,oShape1,oVelocity1);
	if(res != null) return res(oShape2,oVelocity2,oShape1,oVelocity1);
	throw new js__$Boot_HaxeError("[ERROR]:Collision check:Unable to determine collision between thoses class of shape : " + Type.getClassName(Type.getClass(oShape1)) + "; " + Type.getClassName(Type.getClass(oShape2)));
	return null;
};
collider_CollisionCheckerPriorInt._check = function(oShapeA,oVelocity1,oShapeB,oVelocity2) {
	if(js_Boot.__instanceof(oShapeA,space_Vector2i)) {
		if(js_Boot.__instanceof(oShapeB,space_IAlignedAxisBoxi)) return collider_CollisionCheckerPriorInt._vectorAABB_check;
	}
	if(js_Boot.__instanceof(oShapeA,space_IAlignedAxisBoxi)) {
		if(js_Boot.__instanceof(oShapeB,space_IAlignedAxisBoxi)) return collider_CollisionCheckerPriorInt._AABB_check;
		if(js_Boot.__instanceof(oShapeB,space_Circle)) throw new js__$Boot_HaxeError("not implemented");
	}
	if(js_Boot.__instanceof(oShapeA,space_Circle)) {
		if(js_Boot.__instanceof(oShapeB,space_Circle)) throw new js__$Boot_HaxeError("not implemented");
	}
	return null;
};
collider_CollisionCheckerPriorInt._AABB_check = function(oBox1,oVelocity1,oBox2,oVelocity2) {
	collider_CollisionCheckerPriorInt.oCollisionEvent = null;
	var fXCollisionTime = null;
	if(collider_CollisionCheckerPost.axisCollision_get(oBox1.left_get(),oBox1.right_get(),oBox2.left_get(),oBox2.right_get()) > 0) fXCollisionTime = 0; else if(oVelocity1.x > 0) {
		var fTime = collider_CollisionCheckerPriorInt.axisCollisionTime_get(oBox1.right_get(),oVelocity1.x,oBox2.left_get(),0);
		if(fTime != null && fTime >= 0 && fTime <= 1) fXCollisionTime = fTime;
	} else {
		var fTime1 = collider_CollisionCheckerPriorInt.axisCollisionTime_get(oBox1.left_get(),oVelocity1.x,oBox2.right_get(),0);
		if(fTime1 != null && fTime1 >= 0 && fTime1 <= 1) fXCollisionTime = fTime1;
	}
	var fYCollisionTime = null;
	if(collider_CollisionCheckerPost.axisCollision_get(oBox1.bottom_get(),oBox1.top_get(),oBox2.bottom_get(),oBox2.top_get()) > 0) fYCollisionTime = 0; else if(oVelocity1.y > 0) {
		var fTime2 = collider_CollisionCheckerPriorInt.axisCollisionTime_get(oBox1.top_get(),oVelocity1.y,oBox2.bottom_get(),0);
		if(fTime2 != null && fTime2 >= 0 && fTime2 <= 1) fYCollisionTime = fTime2;
	} else {
		var fTime3 = collider_CollisionCheckerPriorInt.axisCollisionTime_get(oBox1.bottom_get(),oVelocity1.y,oBox2.top_get(),0);
		if(fTime3 != null && fTime3 >= 0 && fTime3 <= 1) fYCollisionTime = fTime3;
	}
	if(fXCollisionTime == null || fYCollisionTime == null) return null;
	var oNormal = null;
	if(fXCollisionTime > fYCollisionTime) oNormal = new space_Vector2i(1,0); else oNormal = new space_Vector2i(0,1);
	collider_CollisionCheckerPriorInt.oCollisionEvent = new collider_CollisionEventPriorInt(oBox1,oVelocity1,oBox2,oVelocity2,Math.max(fXCollisionTime,fYCollisionTime),oNormal);
	return collider_CollisionCheckerPriorInt.oCollisionEvent;
};
collider_CollisionCheckerPriorInt._vectorAABB_check = function(oPoint1,oVelocity1,oBox2,oVelocity2) {
	collider_CollisionCheckerPriorInt.oCollisionEvent = null;
	var fXCollisionTime = null;
	if(collider_CollisionCheckerPost.axisCollision2_get(oPoint1.x,oPoint1.x,oBox2.left_get(),oBox2.right_get()) == true) fXCollisionTime = 0; else if(oVelocity1.x > 0) {
		var fTime = collider_CollisionCheckerPriorInt.axisCollisionTime_get(oPoint1.x,oVelocity1.x,oBox2.left_get(),0);
		if(fTime != null && fTime >= 0 && fTime <= 1) fXCollisionTime = fTime;
	} else {
		var fTime1 = collider_CollisionCheckerPriorInt.axisCollisionTime_get(oPoint1.x,oVelocity1.x,oBox2.right_get(),0);
		if(fTime1 != null && fTime1 >= 0 && fTime1 <= 1) fXCollisionTime = fTime1;
	}
	var fYCollisionTime = null;
	if(collider_CollisionCheckerPost.axisCollision2_get(oPoint1.y,oPoint1.y,oBox2.bottom_get(),oBox2.top_get()) == true) fYCollisionTime = 0; else if(oVelocity1.y > 0) {
		var fTime2 = collider_CollisionCheckerPriorInt.axisCollisionTime_get(oPoint1.y,oVelocity1.y,oBox2.bottom_get(),0);
		if(fTime2 != null && fTime2 >= 0 && fTime2 <= 1) fYCollisionTime = fTime2;
	} else {
		var fTime3 = collider_CollisionCheckerPriorInt.axisCollisionTime_get(oPoint1.y,oVelocity1.y,oBox2.top_get(),0);
		if(fTime3 != null && fTime3 >= 0 && fTime3 <= 1) fYCollisionTime = fTime3;
	}
	if(fXCollisionTime == null || fYCollisionTime == null) return null;
	var oNormal = null;
	if(fXCollisionTime > fYCollisionTime) oNormal = new space_Vector2i(1,0); else oNormal = new space_Vector2i(0,1);
	collider_CollisionCheckerPriorInt.oCollisionEvent = new collider_CollisionEventPriorInt(oPoint1,oVelocity1,oBox2,oVelocity2,Math.max(fXCollisionTime,fYCollisionTime),oNormal);
	return collider_CollisionCheckerPriorInt.oCollisionEvent;
};
collider_CollisionCheckerPriorInt.axisCollisionTime_get = function(p1,v1,p2,v2) {
	var fSpeedDelta = v1 - v2;
	if(fSpeedDelta == 0) return null;
	return (p2 - p1) / fSpeedDelta;
};
var collider_CollisionEventPrior = function(oDynamicA,oVelocityA,oDynamicB,oVelocityB,fTime,oNormal) {
	this._oDynamicA = oDynamicA;
	this._oDynamicB = oDynamicB;
	this._oVelocityA = oVelocityA;
	this._oVelocityB = oVelocityB;
	this._fTime = fTime;
	this._oNormal = oNormal;
};
$hxClasses["collider.CollisionEventPrior"] = collider_CollisionEventPrior;
collider_CollisionEventPrior.__name__ = ["collider","CollisionEventPrior"];
collider_CollisionEventPrior.prototype = {
	shapeA_get: function() {
		return this._oDynamicA;
	}
	,shapeB_get: function() {
		return this._oDynamicB;
	}
	,velocityA_get: function() {
		return this._oVelocityA;
	}
	,VelocityB_get: function() {
		return this._oVelocityB;
	}
	,time_get: function() {
		return this._fTime;
	}
	,normal_get: function() {
		return this._oNormal;
	}
	,__class__: collider_CollisionEventPrior
};
var collider_CollisionEventPriorInt = function(oDynamicA,oVelocityA,oDynamicB,oVelocityB,fTime,oNormal) {
	this._oDynamicA = oDynamicA;
	this._oDynamicB = oDynamicB;
	this._oVelocityA = oVelocityA;
	this._oVelocityB = oVelocityB;
	this._fTime = fTime;
	this._oNormal = oNormal;
};
$hxClasses["collider.CollisionEventPriorInt"] = collider_CollisionEventPriorInt;
collider_CollisionEventPriorInt.__name__ = ["collider","CollisionEventPriorInt"];
collider_CollisionEventPriorInt.prototype = {
	shapeA_get: function() {
		return this._oDynamicA;
	}
	,shapeB_get: function() {
		return this._oDynamicB;
	}
	,velocityA_get: function() {
		return this._oVelocityA;
	}
	,VelocityB_get: function() {
		return this._oVelocityB;
	}
	,time_get: function() {
		return this._fTime;
	}
	,normal_get: function() {
		return this._oNormal;
	}
	,__class__: collider_CollisionEventPriorInt
};
var haxe_IMap = function() { };
$hxClasses["haxe.IMap"] = haxe_IMap;
haxe_IMap.__name__ = ["haxe","IMap"];
haxe_IMap.prototype = {
	__class__: haxe_IMap
};
var haxe__$Int64__$_$_$Int64 = function(high,low) {
	this.high = high;
	this.low = low;
};
$hxClasses["haxe._Int64.___Int64"] = haxe__$Int64__$_$_$Int64;
haxe__$Int64__$_$_$Int64.__name__ = ["haxe","_Int64","___Int64"];
haxe__$Int64__$_$_$Int64.prototype = {
	__class__: haxe__$Int64__$_$_$Int64
};
var haxe_Serializer = function() {
	this.buf = new StringBuf();
	this.cache = [];
	this.useCache = haxe_Serializer.USE_CACHE;
	this.useEnumIndex = haxe_Serializer.USE_ENUM_INDEX;
	this.shash = new haxe_ds_StringMap();
	this.scount = 0;
};
$hxClasses["haxe.Serializer"] = haxe_Serializer;
haxe_Serializer.__name__ = ["haxe","Serializer"];
haxe_Serializer.run = function(v) {
	var s = new haxe_Serializer();
	s.serialize(v);
	return s.toString();
};
haxe_Serializer.prototype = {
	toString: function() {
		return this.buf.b;
	}
	,serializeString: function(s) {
		var x = this.shash.get(s);
		if(x != null) {
			this.buf.b += "R";
			if(x == null) this.buf.b += "null"; else this.buf.b += "" + x;
			return;
		}
		this.shash.set(s,this.scount++);
		this.buf.b += "y";
		s = encodeURIComponent(s);
		if(s.length == null) this.buf.b += "null"; else this.buf.b += "" + s.length;
		this.buf.b += ":";
		if(s == null) this.buf.b += "null"; else this.buf.b += "" + s;
	}
	,serializeRef: function(v) {
		var vt = typeof(v);
		var _g1 = 0;
		var _g = this.cache.length;
		while(_g1 < _g) {
			var i = _g1++;
			var ci = this.cache[i];
			if(typeof(ci) == vt && ci == v) {
				this.buf.b += "r";
				if(i == null) this.buf.b += "null"; else this.buf.b += "" + i;
				return true;
			}
		}
		this.cache.push(v);
		return false;
	}
	,serializeFields: function(v) {
		var _g = 0;
		var _g1 = Reflect.fields(v);
		while(_g < _g1.length) {
			var f = _g1[_g];
			++_g;
			this.serializeString(f);
			this.serialize(Reflect.field(v,f));
		}
		this.buf.b += "g";
	}
	,serialize: function(v) {
		{
			var _g = Type["typeof"](v);
			switch(_g[1]) {
			case 0:
				this.buf.b += "n";
				break;
			case 1:
				var v1 = v;
				if(v1 == 0) {
					this.buf.b += "z";
					return;
				}
				this.buf.b += "i";
				if(v1 == null) this.buf.b += "null"; else this.buf.b += "" + v1;
				break;
			case 2:
				var v2 = v;
				if(isNaN(v2)) this.buf.b += "k"; else if(!isFinite(v2)) if(v2 < 0) this.buf.b += "m"; else this.buf.b += "p"; else {
					this.buf.b += "d";
					if(v2 == null) this.buf.b += "null"; else this.buf.b += "" + v2;
				}
				break;
			case 3:
				if(v) this.buf.b += "t"; else this.buf.b += "f";
				break;
			case 6:
				var c = _g[2];
				if(c == String) {
					this.serializeString(v);
					return;
				}
				if(this.useCache && this.serializeRef(v)) return;
				switch(c) {
				case Array:
					var ucount = 0;
					this.buf.b += "a";
					var l = v.length;
					var _g1 = 0;
					while(_g1 < l) {
						var i = _g1++;
						if(v[i] == null) ucount++; else {
							if(ucount > 0) {
								if(ucount == 1) this.buf.b += "n"; else {
									this.buf.b += "u";
									if(ucount == null) this.buf.b += "null"; else this.buf.b += "" + ucount;
								}
								ucount = 0;
							}
							this.serialize(v[i]);
						}
					}
					if(ucount > 0) {
						if(ucount == 1) this.buf.b += "n"; else {
							this.buf.b += "u";
							if(ucount == null) this.buf.b += "null"; else this.buf.b += "" + ucount;
						}
					}
					this.buf.b += "h";
					break;
				case List:
					this.buf.b += "l";
					var v3 = v;
					var _g1_head = v3.h;
					var _g1_val = null;
					while(_g1_head != null) {
						var i1;
						_g1_val = _g1_head[0];
						_g1_head = _g1_head[1];
						i1 = _g1_val;
						this.serialize(i1);
					}
					this.buf.b += "h";
					break;
				case Date:
					var d = v;
					this.buf.b += "v";
					this.buf.add(d.getTime());
					break;
				case haxe_ds_StringMap:
					this.buf.b += "b";
					var v4 = v;
					var $it0 = v4.keys();
					while( $it0.hasNext() ) {
						var k = $it0.next();
						this.serializeString(k);
						this.serialize(__map_reserved[k] != null?v4.getReserved(k):v4.h[k]);
					}
					this.buf.b += "h";
					break;
				case haxe_ds_IntMap:
					this.buf.b += "q";
					var v5 = v;
					var $it1 = v5.keys();
					while( $it1.hasNext() ) {
						var k1 = $it1.next();
						this.buf.b += ":";
						if(k1 == null) this.buf.b += "null"; else this.buf.b += "" + k1;
						this.serialize(v5.h[k1]);
					}
					this.buf.b += "h";
					break;
				case haxe_ds_ObjectMap:
					this.buf.b += "M";
					var v6 = v;
					var $it2 = v6.keys();
					while( $it2.hasNext() ) {
						var k2 = $it2.next();
						var id = Reflect.field(k2,"__id__");
						Reflect.deleteField(k2,"__id__");
						this.serialize(k2);
						k2.__id__ = id;
						this.serialize(v6.h[k2.__id__]);
					}
					this.buf.b += "h";
					break;
				case haxe_io_Bytes:
					var v7 = v;
					var i2 = 0;
					var max = v7.length - 2;
					var charsBuf = new StringBuf();
					var b64 = haxe_Serializer.BASE64;
					while(i2 < max) {
						var b1 = v7.get(i2++);
						var b2 = v7.get(i2++);
						var b3 = v7.get(i2++);
						charsBuf.add(b64.charAt(b1 >> 2));
						charsBuf.add(b64.charAt((b1 << 4 | b2 >> 4) & 63));
						charsBuf.add(b64.charAt((b2 << 2 | b3 >> 6) & 63));
						charsBuf.add(b64.charAt(b3 & 63));
					}
					if(i2 == max) {
						var b11 = v7.get(i2++);
						var b21 = v7.get(i2++);
						charsBuf.add(b64.charAt(b11 >> 2));
						charsBuf.add(b64.charAt((b11 << 4 | b21 >> 4) & 63));
						charsBuf.add(b64.charAt(b21 << 2 & 63));
					} else if(i2 == max + 1) {
						var b12 = v7.get(i2++);
						charsBuf.add(b64.charAt(b12 >> 2));
						charsBuf.add(b64.charAt(b12 << 4 & 63));
					}
					var chars = charsBuf.b;
					this.buf.b += "s";
					if(chars.length == null) this.buf.b += "null"; else this.buf.b += "" + chars.length;
					this.buf.b += ":";
					if(chars == null) this.buf.b += "null"; else this.buf.b += "" + chars;
					break;
				default:
					if(this.useCache) this.cache.pop();
					if(v.hxSerialize != null) {
						this.buf.b += "C";
						this.serializeString(Type.getClassName(c));
						if(this.useCache) this.cache.push(v);
						v.hxSerialize(this);
						this.buf.b += "g";
					} else {
						this.buf.b += "c";
						this.serializeString(Type.getClassName(c));
						if(this.useCache) this.cache.push(v);
						this.serializeFields(v);
					}
				}
				break;
			case 4:
				if(js_Boot.__instanceof(v,Class)) {
					var className = Type.getClassName(v);
					this.buf.b += "A";
					this.serializeString(className);
				} else if(js_Boot.__instanceof(v,Enum)) {
					this.buf.b += "B";
					this.serializeString(Type.getEnumName(v));
				} else {
					if(this.useCache && this.serializeRef(v)) return;
					this.buf.b += "o";
					this.serializeFields(v);
				}
				break;
			case 7:
				var e = _g[2];
				if(this.useCache) {
					if(this.serializeRef(v)) return;
					this.cache.pop();
				}
				if(this.useEnumIndex) this.buf.b += "j"; else this.buf.b += "w";
				this.serializeString(Type.getEnumName(e));
				if(this.useEnumIndex) {
					this.buf.b += ":";
					this.buf.b += Std.string(v[1]);
				} else this.serializeString(v[0]);
				this.buf.b += ":";
				var l1 = v.length;
				this.buf.b += Std.string(l1 - 2);
				var _g11 = 2;
				while(_g11 < l1) {
					var i3 = _g11++;
					this.serialize(v[i3]);
				}
				if(this.useCache) this.cache.push(v);
				break;
			case 5:
				throw new js__$Boot_HaxeError("Cannot serialize function");
				break;
			default:
				throw new js__$Boot_HaxeError("Cannot serialize " + Std.string(v));
			}
		}
	}
	,__class__: haxe_Serializer
};
var haxe_Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
$hxClasses["haxe.Timer"] = haxe_Timer;
haxe_Timer.__name__ = ["haxe","Timer"];
haxe_Timer.prototype = {
	stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
	,__class__: haxe_Timer
};
var haxe_Unserializer = function(buf) {
	this.buf = buf;
	this.length = buf.length;
	this.pos = 0;
	this.scache = [];
	this.cache = [];
	var r = haxe_Unserializer.DEFAULT_RESOLVER;
	if(r == null) {
		r = Type;
		haxe_Unserializer.DEFAULT_RESOLVER = r;
	}
	this.setResolver(r);
};
$hxClasses["haxe.Unserializer"] = haxe_Unserializer;
haxe_Unserializer.__name__ = ["haxe","Unserializer"];
haxe_Unserializer.initCodes = function() {
	var codes = [];
	var _g1 = 0;
	var _g = haxe_Unserializer.BASE64.length;
	while(_g1 < _g) {
		var i = _g1++;
		codes[haxe_Unserializer.BASE64.charCodeAt(i)] = i;
	}
	return codes;
};
haxe_Unserializer.run = function(v) {
	return new haxe_Unserializer(v).unserialize();
};
haxe_Unserializer.prototype = {
	setResolver: function(r) {
		if(r == null) this.resolver = { resolveClass : function(_) {
			return null;
		}, resolveEnum : function(_1) {
			return null;
		}}; else this.resolver = r;
	}
	,get: function(p) {
		return this.buf.charCodeAt(p);
	}
	,readDigits: function() {
		var k = 0;
		var s = false;
		var fpos = this.pos;
		while(true) {
			var c = this.buf.charCodeAt(this.pos);
			if(c != c) break;
			if(c == 45) {
				if(this.pos != fpos) break;
				s = true;
				this.pos++;
				continue;
			}
			if(c < 48 || c > 57) break;
			k = k * 10 + (c - 48);
			this.pos++;
		}
		if(s) k *= -1;
		return k;
	}
	,readFloat: function() {
		var p1 = this.pos;
		while(true) {
			var c = this.buf.charCodeAt(this.pos);
			if(c >= 43 && c < 58 || c == 101 || c == 69) this.pos++; else break;
		}
		return Std.parseFloat(HxOverrides.substr(this.buf,p1,this.pos - p1));
	}
	,unserializeObject: function(o) {
		while(true) {
			if(this.pos >= this.length) throw new js__$Boot_HaxeError("Invalid object");
			if(this.buf.charCodeAt(this.pos) == 103) break;
			var k = this.unserialize();
			if(!(typeof(k) == "string")) throw new js__$Boot_HaxeError("Invalid object key");
			var v = this.unserialize();
			o[k] = v;
		}
		this.pos++;
	}
	,unserializeEnum: function(edecl,tag) {
		if(this.get(this.pos++) != 58) throw new js__$Boot_HaxeError("Invalid enum format");
		var nargs = this.readDigits();
		if(nargs == 0) return Type.createEnum(edecl,tag);
		var args = [];
		while(nargs-- > 0) args.push(this.unserialize());
		return Type.createEnum(edecl,tag,args);
	}
	,unserialize: function() {
		var _g = this.get(this.pos++);
		switch(_g) {
		case 110:
			return null;
		case 116:
			return true;
		case 102:
			return false;
		case 122:
			return 0;
		case 105:
			return this.readDigits();
		case 100:
			return this.readFloat();
		case 121:
			var len = this.readDigits();
			if(this.get(this.pos++) != 58 || this.length - this.pos < len) throw new js__$Boot_HaxeError("Invalid string length");
			var s = HxOverrides.substr(this.buf,this.pos,len);
			this.pos += len;
			s = decodeURIComponent(s.split("+").join(" "));
			this.scache.push(s);
			return s;
		case 107:
			return NaN;
		case 109:
			return -Infinity;
		case 112:
			return Infinity;
		case 97:
			var buf = this.buf;
			var a = [];
			this.cache.push(a);
			while(true) {
				var c = this.buf.charCodeAt(this.pos);
				if(c == 104) {
					this.pos++;
					break;
				}
				if(c == 117) {
					this.pos++;
					var n = this.readDigits();
					a[a.length + n - 1] = null;
				} else a.push(this.unserialize());
			}
			return a;
		case 111:
			var o = { };
			this.cache.push(o);
			this.unserializeObject(o);
			return o;
		case 114:
			var n1 = this.readDigits();
			if(n1 < 0 || n1 >= this.cache.length) throw new js__$Boot_HaxeError("Invalid reference");
			return this.cache[n1];
		case 82:
			var n2 = this.readDigits();
			if(n2 < 0 || n2 >= this.scache.length) throw new js__$Boot_HaxeError("Invalid string reference");
			return this.scache[n2];
		case 120:
			throw new js__$Boot_HaxeError(this.unserialize());
			break;
		case 99:
			var name = this.unserialize();
			var cl = this.resolver.resolveClass(name);
			if(cl == null) throw new js__$Boot_HaxeError("Class not found " + name);
			var o1 = Type.createEmptyInstance(cl);
			this.cache.push(o1);
			this.unserializeObject(o1);
			return o1;
		case 119:
			var name1 = this.unserialize();
			var edecl = this.resolver.resolveEnum(name1);
			if(edecl == null) throw new js__$Boot_HaxeError("Enum not found " + name1);
			var e = this.unserializeEnum(edecl,this.unserialize());
			this.cache.push(e);
			return e;
		case 106:
			var name2 = this.unserialize();
			var edecl1 = this.resolver.resolveEnum(name2);
			if(edecl1 == null) throw new js__$Boot_HaxeError("Enum not found " + name2);
			this.pos++;
			var index = this.readDigits();
			var tag = Type.getEnumConstructs(edecl1)[index];
			if(tag == null) throw new js__$Boot_HaxeError("Unknown enum index " + name2 + "@" + index);
			var e1 = this.unserializeEnum(edecl1,tag);
			this.cache.push(e1);
			return e1;
		case 108:
			var l = new List();
			this.cache.push(l);
			var buf1 = this.buf;
			while(this.buf.charCodeAt(this.pos) != 104) l.add(this.unserialize());
			this.pos++;
			return l;
		case 98:
			var h = new haxe_ds_StringMap();
			this.cache.push(h);
			var buf2 = this.buf;
			while(this.buf.charCodeAt(this.pos) != 104) {
				var s1 = this.unserialize();
				h.set(s1,this.unserialize());
			}
			this.pos++;
			return h;
		case 113:
			var h1 = new haxe_ds_IntMap();
			this.cache.push(h1);
			var buf3 = this.buf;
			var c1 = this.get(this.pos++);
			while(c1 == 58) {
				var i = this.readDigits();
				h1.set(i,this.unserialize());
				c1 = this.get(this.pos++);
			}
			if(c1 != 104) throw new js__$Boot_HaxeError("Invalid IntMap format");
			return h1;
		case 77:
			var h2 = new haxe_ds_ObjectMap();
			this.cache.push(h2);
			var buf4 = this.buf;
			while(this.buf.charCodeAt(this.pos) != 104) {
				var s2 = this.unserialize();
				h2.set(s2,this.unserialize());
			}
			this.pos++;
			return h2;
		case 118:
			var d;
			if(this.buf.charCodeAt(this.pos) >= 48 && this.buf.charCodeAt(this.pos) <= 57 && this.buf.charCodeAt(this.pos + 1) >= 48 && this.buf.charCodeAt(this.pos + 1) <= 57 && this.buf.charCodeAt(this.pos + 2) >= 48 && this.buf.charCodeAt(this.pos + 2) <= 57 && this.buf.charCodeAt(this.pos + 3) >= 48 && this.buf.charCodeAt(this.pos + 3) <= 57 && this.buf.charCodeAt(this.pos + 4) == 45) {
				var s3 = HxOverrides.substr(this.buf,this.pos,19);
				d = HxOverrides.strDate(s3);
				this.pos += 19;
			} else {
				var t = this.readFloat();
				var d1 = new Date();
				d1.setTime(t);
				d = d1;
			}
			this.cache.push(d);
			return d;
		case 115:
			var len1 = this.readDigits();
			var buf5 = this.buf;
			if(this.get(this.pos++) != 58 || this.length - this.pos < len1) throw new js__$Boot_HaxeError("Invalid bytes length");
			var codes = haxe_Unserializer.CODES;
			if(codes == null) {
				codes = haxe_Unserializer.initCodes();
				haxe_Unserializer.CODES = codes;
			}
			var i1 = this.pos;
			var rest = len1 & 3;
			var size;
			size = (len1 >> 2) * 3 + (rest >= 2?rest - 1:0);
			var max = i1 + (len1 - rest);
			var bytes = haxe_io_Bytes.alloc(size);
			var bpos = 0;
			while(i1 < max) {
				var c11 = codes[StringTools.fastCodeAt(buf5,i1++)];
				var c2 = codes[StringTools.fastCodeAt(buf5,i1++)];
				bytes.set(bpos++,c11 << 2 | c2 >> 4);
				var c3 = codes[StringTools.fastCodeAt(buf5,i1++)];
				bytes.set(bpos++,c2 << 4 | c3 >> 2);
				var c4 = codes[StringTools.fastCodeAt(buf5,i1++)];
				bytes.set(bpos++,c3 << 6 | c4);
			}
			if(rest >= 2) {
				var c12 = codes[StringTools.fastCodeAt(buf5,i1++)];
				var c21 = codes[StringTools.fastCodeAt(buf5,i1++)];
				bytes.set(bpos++,c12 << 2 | c21 >> 4);
				if(rest == 3) {
					var c31 = codes[StringTools.fastCodeAt(buf5,i1++)];
					bytes.set(bpos++,c21 << 4 | c31 >> 2);
				}
			}
			this.pos += len1;
			this.cache.push(bytes);
			return bytes;
		case 67:
			var name3 = this.unserialize();
			var cl1 = this.resolver.resolveClass(name3);
			if(cl1 == null) throw new js__$Boot_HaxeError("Class not found " + name3);
			var o2 = Type.createEmptyInstance(cl1);
			this.cache.push(o2);
			o2.hxUnserialize(this);
			if(this.get(this.pos++) != 103) throw new js__$Boot_HaxeError("Invalid custom data");
			return o2;
		case 65:
			var name4 = this.unserialize();
			var cl2 = this.resolver.resolveClass(name4);
			if(cl2 == null) throw new js__$Boot_HaxeError("Class not found " + name4);
			return cl2;
		case 66:
			var name5 = this.unserialize();
			var e2 = this.resolver.resolveEnum(name5);
			if(e2 == null) throw new js__$Boot_HaxeError("Enum not found " + name5);
			return e2;
		default:
		}
		this.pos--;
		throw new js__$Boot_HaxeError("Invalid char " + this.buf.charAt(this.pos) + " at position " + this.pos);
	}
	,__class__: haxe_Unserializer
};
var haxe_crypto_Sha1 = function() {
};
$hxClasses["haxe.crypto.Sha1"] = haxe_crypto_Sha1;
haxe_crypto_Sha1.__name__ = ["haxe","crypto","Sha1"];
haxe_crypto_Sha1.encode = function(s) {
	var sh = new haxe_crypto_Sha1();
	var h = sh.doEncode(haxe_crypto_Sha1.str2blks(s));
	return sh.hex(h);
};
haxe_crypto_Sha1.str2blks = function(s) {
	var nblk = (s.length + 8 >> 6) + 1;
	var blks = [];
	var _g1 = 0;
	var _g = nblk * 16;
	while(_g1 < _g) {
		var i1 = _g1++;
		blks[i1] = 0;
	}
	var _g11 = 0;
	var _g2 = s.length;
	while(_g11 < _g2) {
		var i2 = _g11++;
		var p1 = i2 >> 2;
		blks[p1] |= HxOverrides.cca(s,i2) << 24 - ((i2 & 3) << 3);
	}
	var i = s.length;
	var p = i >> 2;
	blks[p] |= 128 << 24 - ((i & 3) << 3);
	blks[nblk * 16 - 1] = s.length * 8;
	return blks;
};
haxe_crypto_Sha1.prototype = {
	doEncode: function(x) {
		var w = [];
		var a = 1732584193;
		var b = -271733879;
		var c = -1732584194;
		var d = 271733878;
		var e = -1009589776;
		var i = 0;
		while(i < x.length) {
			var olda = a;
			var oldb = b;
			var oldc = c;
			var oldd = d;
			var olde = e;
			var j = 0;
			while(j < 80) {
				if(j < 16) w[j] = x[i + j]; else w[j] = this.rol(w[j - 3] ^ w[j - 8] ^ w[j - 14] ^ w[j - 16],1);
				var t = (a << 5 | a >>> 27) + this.ft(j,b,c,d) + e + w[j] + this.kt(j);
				e = d;
				d = c;
				c = b << 30 | b >>> 2;
				b = a;
				a = t;
				j++;
			}
			a += olda;
			b += oldb;
			c += oldc;
			d += oldd;
			e += olde;
			i += 16;
		}
		return [a,b,c,d,e];
	}
	,rol: function(num,cnt) {
		return num << cnt | num >>> 32 - cnt;
	}
	,ft: function(t,b,c,d) {
		if(t < 20) return b & c | ~b & d;
		if(t < 40) return b ^ c ^ d;
		if(t < 60) return b & c | b & d | c & d;
		return b ^ c ^ d;
	}
	,kt: function(t) {
		if(t < 20) return 1518500249;
		if(t < 40) return 1859775393;
		if(t < 60) return -1894007588;
		return -899497514;
	}
	,hex: function(a) {
		var str = "";
		var _g = 0;
		while(_g < a.length) {
			var num = a[_g];
			++_g;
			str += StringTools.hex(num,8);
		}
		return str.toLowerCase();
	}
	,__class__: haxe_crypto_Sha1
};
var haxe_ds_IntMap = function() {
	this.h = { };
};
$hxClasses["haxe.ds.IntMap"] = haxe_ds_IntMap;
haxe_ds_IntMap.__name__ = ["haxe","ds","IntMap"];
haxe_ds_IntMap.__interfaces__ = [haxe_IMap];
haxe_ds_IntMap.prototype = {
	set: function(key,value) {
		this.h[key] = value;
	}
	,get: function(key) {
		return this.h[key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty(key);
	}
	,remove: function(key) {
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key | 0);
		}
		return HxOverrides.iter(a);
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i];
		}};
	}
	,__class__: haxe_ds_IntMap
};
var haxe_ds_ObjectMap = function() {
	this.h = { };
	this.h.__keys__ = { };
};
$hxClasses["haxe.ds.ObjectMap"] = haxe_ds_ObjectMap;
haxe_ds_ObjectMap.__name__ = ["haxe","ds","ObjectMap"];
haxe_ds_ObjectMap.__interfaces__ = [haxe_IMap];
haxe_ds_ObjectMap.prototype = {
	set: function(key,value) {
		var id = key.__id__ || (key.__id__ = ++haxe_ds_ObjectMap.count);
		this.h[id] = value;
		this.h.__keys__[id] = key;
	}
	,get: function(key) {
		return this.h[key.__id__];
	}
	,keys: function() {
		var a = [];
		for( var key in this.h.__keys__ ) {
		if(this.h.hasOwnProperty(key)) a.push(this.h.__keys__[key]);
		}
		return HxOverrides.iter(a);
	}
	,__class__: haxe_ds_ObjectMap
};
var haxe_ds__$StringMap_StringMapIterator = function(map,keys) {
	this.map = map;
	this.keys = keys;
	this.index = 0;
	this.count = keys.length;
};
$hxClasses["haxe.ds._StringMap.StringMapIterator"] = haxe_ds__$StringMap_StringMapIterator;
haxe_ds__$StringMap_StringMapIterator.__name__ = ["haxe","ds","_StringMap","StringMapIterator"];
haxe_ds__$StringMap_StringMapIterator.prototype = {
	hasNext: function() {
		return this.index < this.count;
	}
	,next: function() {
		return this.map.get(this.keys[this.index++]);
	}
	,__class__: haxe_ds__$StringMap_StringMapIterator
};
var haxe_ds_StringMap = function() {
	this.h = { };
};
$hxClasses["haxe.ds.StringMap"] = haxe_ds_StringMap;
haxe_ds_StringMap.__name__ = ["haxe","ds","StringMap"];
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.prototype = {
	set: function(key,value) {
		if(__map_reserved[key] != null) this.setReserved(key,value); else this.h[key] = value;
	}
	,get: function(key) {
		if(__map_reserved[key] != null) return this.getReserved(key);
		return this.h[key];
	}
	,exists: function(key) {
		if(__map_reserved[key] != null) return this.existsReserved(key);
		return this.h.hasOwnProperty(key);
	}
	,setReserved: function(key,value) {
		if(this.rh == null) this.rh = { };
		this.rh["$" + key] = value;
	}
	,getReserved: function(key) {
		if(this.rh == null) return null; else return this.rh["$" + key];
	}
	,existsReserved: function(key) {
		if(this.rh == null) return false;
		return this.rh.hasOwnProperty("$" + key);
	}
	,remove: function(key) {
		if(__map_reserved[key] != null) {
			key = "$" + key;
			if(this.rh == null || !this.rh.hasOwnProperty(key)) return false;
			delete(this.rh[key]);
			return true;
		} else {
			if(!this.h.hasOwnProperty(key)) return false;
			delete(this.h[key]);
			return true;
		}
	}
	,keys: function() {
		var _this = this.arrayKeys();
		return HxOverrides.iter(_this);
	}
	,arrayKeys: function() {
		var out = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) out.push(key);
		}
		if(this.rh != null) {
			for( var key in this.rh ) {
			if(key.charCodeAt(0) == 36) out.push(key.substr(1));
			}
		}
		return out;
	}
	,iterator: function() {
		return new haxe_ds__$StringMap_StringMapIterator(this,this.arrayKeys());
	}
	,__class__: haxe_ds_StringMap
};
var haxe_io_Bytes = function(data) {
	this.length = data.byteLength;
	this.b = new Uint8Array(data);
	this.b.bufferValue = data;
	data.hxBytes = this;
	data.bytes = this.b;
};
$hxClasses["haxe.io.Bytes"] = haxe_io_Bytes;
haxe_io_Bytes.__name__ = ["haxe","io","Bytes"];
haxe_io_Bytes.alloc = function(length) {
	return new haxe_io_Bytes(new ArrayBuffer(length));
};
haxe_io_Bytes.prototype = {
	get: function(pos) {
		return this.b[pos];
	}
	,set: function(pos,v) {
		this.b[pos] = v & 255;
	}
	,__class__: haxe_io_Bytes
};
var haxe_io_Error = $hxClasses["haxe.io.Error"] = { __ename__ : ["haxe","io","Error"], __constructs__ : ["Blocked","Overflow","OutsideBounds","Custom"] };
haxe_io_Error.Blocked = ["Blocked",0];
haxe_io_Error.Blocked.toString = $estr;
haxe_io_Error.Blocked.__enum__ = haxe_io_Error;
haxe_io_Error.Overflow = ["Overflow",1];
haxe_io_Error.Overflow.toString = $estr;
haxe_io_Error.Overflow.__enum__ = haxe_io_Error;
haxe_io_Error.OutsideBounds = ["OutsideBounds",2];
haxe_io_Error.OutsideBounds.toString = $estr;
haxe_io_Error.OutsideBounds.__enum__ = haxe_io_Error;
haxe_io_Error.Custom = function(e) { var $x = ["Custom",3,e]; $x.__enum__ = haxe_io_Error; $x.toString = $estr; return $x; };
var haxe_io_FPHelper = function() { };
$hxClasses["haxe.io.FPHelper"] = haxe_io_FPHelper;
haxe_io_FPHelper.__name__ = ["haxe","io","FPHelper"];
haxe_io_FPHelper.i32ToFloat = function(i) {
	var sign = 1 - (i >>> 31 << 1);
	var exp = i >>> 23 & 255;
	var sig = i & 8388607;
	if(sig == 0 && exp == 0) return 0.0;
	return sign * (1 + Math.pow(2,-23) * sig) * Math.pow(2,exp - 127);
};
haxe_io_FPHelper.floatToI32 = function(f) {
	if(f == 0) return 0;
	var af;
	if(f < 0) af = -f; else af = f;
	var exp = Math.floor(Math.log(af) / 0.6931471805599453);
	if(exp < -127) exp = -127; else if(exp > 128) exp = 128;
	var sig = Math.round((af / Math.pow(2,exp) - 1) * 8388608) & 8388607;
	return (f < 0?-2147483648:0) | exp + 127 << 23 | sig;
};
haxe_io_FPHelper.i64ToDouble = function(low,high) {
	var sign = 1 - (high >>> 31 << 1);
	var exp = (high >> 20 & 2047) - 1023;
	var sig = (high & 1048575) * 4294967296. + (low >>> 31) * 2147483648. + (low & 2147483647);
	if(sig == 0 && exp == -1023) return 0.0;
	return sign * (1.0 + Math.pow(2,-52) * sig) * Math.pow(2,exp);
};
haxe_io_FPHelper.doubleToI64 = function(v) {
	var i64 = haxe_io_FPHelper.i64tmp;
	if(v == 0) {
		i64.low = 0;
		i64.high = 0;
	} else {
		var av;
		if(v < 0) av = -v; else av = v;
		var exp = Math.floor(Math.log(av) / 0.6931471805599453);
		var sig;
		var v1 = (av / Math.pow(2,exp) - 1) * 4503599627370496.;
		sig = Math.round(v1);
		var sig_l = sig | 0;
		var sig_h = sig / 4294967296.0 | 0;
		i64.low = sig_l;
		i64.high = (v < 0?-2147483648:0) | exp + 1023 << 20 | sig_h;
	}
	return i64;
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) Error.captureStackTrace(this,js__$Boot_HaxeError);
};
$hxClasses["js._Boot.HaxeError"] = js__$Boot_HaxeError;
js__$Boot_HaxeError.__name__ = ["js","_Boot","HaxeError"];
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	__class__: js__$Boot_HaxeError
});
var js_Boot = function() { };
$hxClasses["js.Boot"] = js_Boot;
js_Boot.__name__ = ["js","Boot"];
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else {
		var cl = o.__class__;
		if(cl != null) return cl;
		var name = js_Boot.__nativeClassName(o);
		if(name != null) return js_Boot.__resolveNativeClass(name);
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js_Boot.__string_rec(o[i1],s); else str2 += js_Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) return true;
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js_Boot.__cast = function(o,t) {
	if(js_Boot.__instanceof(o,t)) return o; else throw new js__$Boot_HaxeError("Cannot cast " + Std.string(o) + " to " + Std.string(t));
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") return null;
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
var js_Lib = function() { };
$hxClasses["js.Lib"] = js_Lib;
js_Lib.__name__ = ["js","Lib"];
js_Lib.alert = function(v) {
	alert(js_Boot.__string_rec(v,""));
};
var js_html_compat_ArrayBuffer = function(a) {
	if((a instanceof Array) && a.__enum__ == null) {
		this.a = a;
		this.byteLength = a.length;
	} else {
		var len = a;
		this.a = [];
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			this.a[i] = 0;
		}
		this.byteLength = len;
	}
};
$hxClasses["js.html.compat.ArrayBuffer"] = js_html_compat_ArrayBuffer;
js_html_compat_ArrayBuffer.__name__ = ["js","html","compat","ArrayBuffer"];
js_html_compat_ArrayBuffer.sliceImpl = function(begin,end) {
	var u = new Uint8Array(this,begin,end == null?null:end - begin);
	var result = new ArrayBuffer(u.byteLength);
	var resultArray = new Uint8Array(result);
	resultArray.set(u);
	return result;
};
js_html_compat_ArrayBuffer.prototype = {
	slice: function(begin,end) {
		return new js_html_compat_ArrayBuffer(this.a.slice(begin,end));
	}
	,__class__: js_html_compat_ArrayBuffer
};
var js_html_compat_DataView = function(buffer,byteOffset,byteLength) {
	this.buf = buffer;
	if(byteOffset == null) this.offset = 0; else this.offset = byteOffset;
	if(byteLength == null) this.length = buffer.byteLength - this.offset; else this.length = byteLength;
	if(this.offset < 0 || this.length < 0 || this.offset + this.length > buffer.byteLength) throw new js__$Boot_HaxeError(haxe_io_Error.OutsideBounds);
};
$hxClasses["js.html.compat.DataView"] = js_html_compat_DataView;
js_html_compat_DataView.__name__ = ["js","html","compat","DataView"];
js_html_compat_DataView.prototype = {
	getInt8: function(byteOffset) {
		var v = this.buf.a[this.offset + byteOffset];
		if(v >= 128) return v - 256; else return v;
	}
	,getUint8: function(byteOffset) {
		return this.buf.a[this.offset + byteOffset];
	}
	,getInt16: function(byteOffset,littleEndian) {
		var v = this.getUint16(byteOffset,littleEndian);
		if(v >= 32768) return v - 65536; else return v;
	}
	,getUint16: function(byteOffset,littleEndian) {
		if(littleEndian) return this.buf.a[this.offset + byteOffset] | this.buf.a[this.offset + byteOffset + 1] << 8; else return this.buf.a[this.offset + byteOffset] << 8 | this.buf.a[this.offset + byteOffset + 1];
	}
	,getInt32: function(byteOffset,littleEndian) {
		var p = this.offset + byteOffset;
		var a = this.buf.a[p++];
		var b = this.buf.a[p++];
		var c = this.buf.a[p++];
		var d = this.buf.a[p++];
		if(littleEndian) return a | b << 8 | c << 16 | d << 24; else return d | c << 8 | b << 16 | a << 24;
	}
	,getUint32: function(byteOffset,littleEndian) {
		var v = this.getInt32(byteOffset,littleEndian);
		if(v < 0) return v + 4294967296.; else return v;
	}
	,getFloat32: function(byteOffset,littleEndian) {
		return haxe_io_FPHelper.i32ToFloat(this.getInt32(byteOffset,littleEndian));
	}
	,getFloat64: function(byteOffset,littleEndian) {
		var a = this.getInt32(byteOffset,littleEndian);
		var b = this.getInt32(byteOffset + 4,littleEndian);
		return haxe_io_FPHelper.i64ToDouble(littleEndian?a:b,littleEndian?b:a);
	}
	,setInt8: function(byteOffset,value) {
		if(value < 0) this.buf.a[byteOffset + this.offset] = value + 128 & 255; else this.buf.a[byteOffset + this.offset] = value & 255;
	}
	,setUint8: function(byteOffset,value) {
		this.buf.a[byteOffset + this.offset] = value & 255;
	}
	,setInt16: function(byteOffset,value,littleEndian) {
		this.setUint16(byteOffset,value < 0?value + 65536:value,littleEndian);
	}
	,setUint16: function(byteOffset,value,littleEndian) {
		var p = byteOffset + this.offset;
		if(littleEndian) {
			this.buf.a[p] = value & 255;
			this.buf.a[p++] = value >> 8 & 255;
		} else {
			this.buf.a[p++] = value >> 8 & 255;
			this.buf.a[p] = value & 255;
		}
	}
	,setInt32: function(byteOffset,value,littleEndian) {
		this.setUint32(byteOffset,value,littleEndian);
	}
	,setUint32: function(byteOffset,value,littleEndian) {
		var p = byteOffset + this.offset;
		if(littleEndian) {
			this.buf.a[p++] = value & 255;
			this.buf.a[p++] = value >> 8 & 255;
			this.buf.a[p++] = value >> 16 & 255;
			this.buf.a[p++] = value >>> 24;
		} else {
			this.buf.a[p++] = value >>> 24;
			this.buf.a[p++] = value >> 16 & 255;
			this.buf.a[p++] = value >> 8 & 255;
			this.buf.a[p++] = value & 255;
		}
	}
	,setFloat32: function(byteOffset,value,littleEndian) {
		this.setUint32(byteOffset,haxe_io_FPHelper.floatToI32(value),littleEndian);
	}
	,setFloat64: function(byteOffset,value,littleEndian) {
		var i64 = haxe_io_FPHelper.doubleToI64(value);
		if(littleEndian) {
			this.setUint32(byteOffset,i64.low);
			this.setUint32(byteOffset,i64.high);
		} else {
			this.setUint32(byteOffset,i64.high);
			this.setUint32(byteOffset,i64.low);
		}
	}
	,__class__: js_html_compat_DataView
};
var js_html_compat_Uint8Array = function() { };
$hxClasses["js.html.compat.Uint8Array"] = js_html_compat_Uint8Array;
js_html_compat_Uint8Array.__name__ = ["js","html","compat","Uint8Array"];
js_html_compat_Uint8Array._new = function(arg1,offset,length) {
	var arr;
	if(typeof(arg1) == "number") {
		arr = [];
		var _g = 0;
		while(_g < arg1) {
			var i = _g++;
			arr[i] = 0;
		}
		arr.byteLength = arr.length;
		arr.byteOffset = 0;
		arr.buffer = new js_html_compat_ArrayBuffer(arr);
	} else if(js_Boot.__instanceof(arg1,js_html_compat_ArrayBuffer)) {
		var buffer = arg1;
		if(offset == null) offset = 0;
		if(length == null) length = buffer.byteLength - offset;
		if(offset == 0) arr = buffer.a; else arr = buffer.a.slice(offset,offset + length);
		arr.byteLength = arr.length;
		arr.byteOffset = offset;
		arr.buffer = buffer;
	} else if((arg1 instanceof Array) && arg1.__enum__ == null) {
		arr = arg1.slice();
		arr.byteLength = arr.length;
		arr.byteOffset = 0;
		arr.buffer = new js_html_compat_ArrayBuffer(arr);
	} else throw new js__$Boot_HaxeError("TODO " + Std.string(arg1));
	arr.subarray = js_html_compat_Uint8Array._subarray;
	arr.set = js_html_compat_Uint8Array._set;
	return arr;
};
js_html_compat_Uint8Array._set = function(arg,offset) {
	var t = this;
	if(js_Boot.__instanceof(arg.buffer,js_html_compat_ArrayBuffer)) {
		var a = arg;
		if(arg.byteLength + offset > t.byteLength) throw new js__$Boot_HaxeError("set() outside of range");
		var _g1 = 0;
		var _g = arg.byteLength;
		while(_g1 < _g) {
			var i = _g1++;
			t[i + offset] = a[i];
		}
	} else if((arg instanceof Array) && arg.__enum__ == null) {
		var a1 = arg;
		if(a1.length + offset > t.byteLength) throw new js__$Boot_HaxeError("set() outside of range");
		var _g11 = 0;
		var _g2 = a1.length;
		while(_g11 < _g2) {
			var i1 = _g11++;
			t[i1 + offset] = a1[i1];
		}
	} else throw new js__$Boot_HaxeError("TODO");
};
js_html_compat_Uint8Array._subarray = function(start,end) {
	var t = this;
	var a = js_html_compat_Uint8Array._new(t.slice(start,end));
	a.byteOffset = start;
	return a;
};
var trigger_IEventDispatcher = function() { };
$hxClasses["trigger.IEventDispatcher"] = trigger_IEventDispatcher;
trigger_IEventDispatcher.__name__ = ["trigger","IEventDispatcher"];
trigger_IEventDispatcher.prototype = {
	__class__: trigger_IEventDispatcher
};
var trigger_eventdispatcher_EventDispatcher = function() {
	this._aoTrigger = [];
};
$hxClasses["trigger.eventdispatcher.EventDispatcher"] = trigger_eventdispatcher_EventDispatcher;
trigger_eventdispatcher_EventDispatcher.__name__ = ["trigger","eventdispatcher","EventDispatcher"];
trigger_eventdispatcher_EventDispatcher.__interfaces__ = [trigger_IEventDispatcher];
trigger_eventdispatcher_EventDispatcher.prototype = {
	attach: function(oITrigger) {
		this._aoTrigger.push(oITrigger);
	}
	,remove: function(oITrigger) {
		HxOverrides.remove(this._aoTrigger,oITrigger);
	}
	,event_get: function() {
		return this._oEventCurrent;
	}
	,dispatch: function(oEvent) {
		this._oEventCurrent = oEvent;
		var _g = 0;
		var _g1 = this._aoTrigger;
		while(_g < _g1.length) {
			var oTrigger = _g1[_g];
			++_g;
			oTrigger.trigger(this);
		}
		return this;
	}
	,__class__: trigger_eventdispatcher_EventDispatcher
};
var legion_Game = function() {
	this._iIdAutoIncrement = 0;
	this._aoEntity = [];
	this._mSingleton = new haxe_ds_StringMap();
	this.onEntityNew = new trigger_EventDispatcher2();
	this.onEntityUpdate = new trigger_EventDispatcher2();
	this.onEntityDispose = new trigger_EventDispatcher2();
	this.onAbilityDispose = new trigger_EventDispatcher2();
};
$hxClasses["legion.Game"] = legion_Game;
legion_Game.__name__ = ["legion","Game"];
legion_Game.prototype = {
	entity_get: function(i) {
		var _g = 0;
		var _g1 = this._aoEntity;
		while(_g < _g1.length) {
			var oEntity = _g1[_g];
			++_g;
			if(oEntity.identity_get() == i) return oEntity;
		}
		return null;
	}
	,entity_get_all: function() {
		return this._aoEntity;
	}
	,query_get: function(oClass) {
		return this._mSingleton.get(Type.getClassName(oClass));
	}
	,singleton_get: function(oClass) {
		return this._mSingleton.get(Type.getClassName(oClass));
	}
	,action_run: function(oAction) {
		throw new js__$Boot_HaxeError("I am abstract");
		return true;
	}
	,entity_add: function(oEntity) {
		oEntity.identity_set(this._iIdAutoIncrement);
		this._aoEntity.push(oEntity);
		this._iIdAutoIncrement++;
		this.onEntityNew.dispatch(oEntity);
	}
	,entity_remove: function(oEntity) {
		HxOverrides.remove(this._aoEntity,oEntity);
		this.onEntityDispose.dispatch(oEntity);
	}
	,_start: function() {
		legion_Game.onAnyStart.dispatch(this);
	}
	,_singleton_add: function(o) {
		this._mSingleton.set(Type.getClassName(Type.getClass(o)),o);
	}
	,__class__: legion_Game
};
var legion_IAction = function() { };
$hxClasses["legion.IAction"] = legion_IAction;
legion_IAction.__name__ = ["legion","IAction"];
legion_IAction.prototype = {
	__class__: legion_IAction
};
var legion_IQuery = function() { };
$hxClasses["legion.IQuery"] = legion_IQuery;
legion_IQuery.__name__ = ["legion","IQuery"];
legion_IQuery.prototype = {
	__class__: legion_IQuery
};
var legion_PlayerInput = function(oPlayer) {
	this._oPlayer = oPlayer;
};
$hxClasses["legion.PlayerInput"] = legion_PlayerInput;
legion_PlayerInput.__name__ = ["legion","PlayerInput"];
legion_PlayerInput.prototype = {
	exec: function() {
	}
	,check: function() {
		return true;
	}
	,__class__: legion_PlayerInput
};
var legion_ability_IAbility = function() { };
$hxClasses["legion.ability.IAbility"] = legion_ability_IAbility;
legion_ability_IAbility.__name__ = ["legion","ability","IAbility"];
legion_ability_IAbility.prototype = {
	__class__: legion_ability_IAbility
};
var legion_device_Device = function() { };
$hxClasses["legion.device.Device"] = legion_device_Device;
legion_device_Device.__name__ = ["legion","device","Device"];
var trigger_ITrigger = function() { };
$hxClasses["trigger.ITrigger"] = trigger_ITrigger;
trigger_ITrigger.__name__ = ["trigger","ITrigger"];
trigger_ITrigger.prototype = {
	__class__: trigger_ITrigger
};
var legion_device_Keyboard = function() {
	this._abKeyState = [];
	this.onUpdate = new trigger_eventdispatcher_EventDispatcherTree(legion_device_Device.onUpdate);
	this.onPress = new trigger_eventdispatcher_EventDispatcherTree(this.onUpdate);
	this.onRelease = new trigger_eventdispatcher_EventDispatcherTree(this.onUpdate);
	new trigger_eventdispatcher_EventDispatcherJS("keydown").attach(this);
	new trigger_eventdispatcher_EventDispatcherJS("keyup").attach(this);
};
$hxClasses["legion.device.Keyboard"] = legion_device_Keyboard;
legion_device_Keyboard.__name__ = ["legion","device","Keyboard"];
legion_device_Keyboard.__interfaces__ = [trigger_ITrigger];
legion_device_Keyboard.prototype = {
	keyState_get: function(i) {
		return this._abKeyState[i];
	}
	,keyTrigger_get: function() {
		return this._lastModifiedKey;
	}
	,_autoUpdate: function(oEvent) {
		this._lastModifiedKey = oEvent.keyCode || oEvent.which;
		var _g = oEvent.type;
		switch(_g) {
		case "keydown":
			if(this._abKeyState[this._lastModifiedKey] != true) {
				this._abKeyState[this._lastModifiedKey] = true;
				this.onPress.dispatch(this);
			}
			break;
		case "keyup":
			this._abKeyState[this._lastModifiedKey] = false;
			this.onRelease.dispatch(this);
			break;
		}
	}
	,trigger: function(oSource) {
		if(Std["is"](oSource.event_get(),KeyboardEvent)) this._autoUpdate(oSource.event_get());
	}
	,__class__: legion_device_Keyboard
};
var legion_device_Mouse = function(oEventTarget) {
	this._JSClick = new trigger_eventdispatcher_EventDispatcherJS("click",oEventTarget);
	this._JSMouseUp = new trigger_eventdispatcher_EventDispatcherJS("mouseup",oEventTarget);
	this._JSMouseDown = new trigger_eventdispatcher_EventDispatcherJS("mousedown",oEventTarget);
	this._JSMouseMove = new trigger_eventdispatcher_EventDispatcherJS("mousemove",oEventTarget);
	this._JSContextMenu = new trigger_eventdispatcher_EventDispatcherJS("contextmenu",oEventTarget);
	this._JSClick.attach(this);
	this._JSMouseUp.attach(this);
	this._JSMouseDown.attach(this);
	this._JSMouseMove.attach(this);
	this._JSContextMenu.attach(this);
	this._abButtonState = [];
	this.onUpdate = new trigger_eventdispatcher_EventDispatcherTree(legion_device_Device.onUpdate);
	this.onPress = new trigger_eventdispatcher_EventDispatcherTree(this.onUpdate);
	this.onPressLeft = new trigger_eventdispatcher_EventDispatcherTree(this.onPress);
	this.onPressMiddle = new trigger_eventdispatcher_EventDispatcherTree(this.onPress);
	this.onPressRight = new trigger_eventdispatcher_EventDispatcherTree(this.onPress);
	this.onRelease = new trigger_eventdispatcher_EventDispatcherTree(this.onUpdate);
	this.onReleaseLeft = new trigger_eventdispatcher_EventDispatcherTree(this.onRelease);
	this.onReleaseMiddle = new trigger_eventdispatcher_EventDispatcherTree(this.onRelease);
	this.onReleaseRight = new trigger_eventdispatcher_EventDispatcherTree(this.onRelease);
	this.onMove = new trigger_eventdispatcher_EventDispatcherTree(this.onUpdate);
};
$hxClasses["legion.device.Mouse"] = legion_device_Mouse;
legion_device_Mouse.__name__ = ["legion","device","Mouse"];
legion_device_Mouse.__interfaces__ = [trigger_ITrigger];
legion_device_Mouse.prototype = {
	x_get: function() {
		return this._x;
	}
	,y_get: function() {
		return this._y;
	}
	,buttonState_get: function(i) {
		return this._abButtonState[i];
	}
	,leftButtonState_get: function() {
		return this.buttonState_get(0);
	}
	,middleButtonState_get: function() {
		return this.buttonState_get(1);
	}
	,rightButtonState_get: function() {
		return this.buttonState_get(2);
	}
	,_autoUpdate: function(oEvent) {
		this._x = oEvent.clientX;
		this._y = oEvent.clientY;
		if(oEvent.type == "mouseup") this._abButtonState[oEvent.button] = false;
		if(oEvent.type == "mousedown") this._abButtonState[oEvent.button] = true;
		var _g = oEvent.type;
		switch(_g) {
		case "mousedown":
			var _g1 = oEvent.button;
			switch(_g1) {
			case 0:
				this.onPressLeft.dispatch(this);
				break;
			case 1:
				this.onPressMiddle.dispatch(this);
				break;
			case 2:
				this.onPressRight.dispatch(this);
				break;
			}
			break;
		case "mouseup":
			var _g11 = oEvent.button;
			switch(_g11) {
			case 0:
				this.onReleaseLeft.dispatch(this);
				break;
			case 1:
				this.onReleaseMiddle.dispatch(this);
				break;
			case 2:
				this.onReleaseRight.dispatch(this);
				break;
			}
			break;
		case "mousemove":
			this.onMove.dispatch(this);
			break;
		}
		oEvent.preventDefault();
		oEvent.stopPropagation();
	}
	,trigger: function(oSource) {
		if(Std["is"](oSource.event_get(),MouseEvent)) this._autoUpdate(oSource.event_get());
	}
	,__class__: legion_device_Mouse
};
var legion_device_MegaMouse = function(oEventTarget) {
	legion_device_Mouse.call(this,oEventTarget);
	this.onWheel = new trigger_eventdispatcher_EventDispatcherTree(this.onUpdate);
	this.EDWheel = new trigger_eventdispatcher_EventDispatcherJS("wheel",oEventTarget);
	this.EDWheel.attach(this);
};
$hxClasses["legion.device.MegaMouse"] = legion_device_MegaMouse;
legion_device_MegaMouse.__name__ = ["legion","device","MegaMouse"];
legion_device_MegaMouse.__super__ = legion_device_Mouse;
legion_device_MegaMouse.prototype = $extend(legion_device_Mouse.prototype,{
	wheel_get: function() {
		return this._wheel;
	}
	,_wheelupdate: function(oEvent) {
		var event = oEvent;
		if(Object.prototype.hasOwnProperty.call(event,"wheelDelta")) this._wheel = -event.wheelDelta / 40; else this._wheel = event.deltaY;
		this._wheel = -this._wheel / 3;
		this.onWheel.dispatch(this);
	}
	,trigger: function(oSource) {
		if(oSource == this.EDWheel) this._wheelupdate(oSource.event_get()); else legion_device_Mouse.prototype.trigger.call(this,oSource);
	}
	,__class__: legion_device_MegaMouse
});
var utils_IDisposable = function() { };
$hxClasses["utils.IDisposable"] = utils_IDisposable;
utils_IDisposable.__name__ = ["utils","IDisposable"];
utils_IDisposable.prototype = {
	__class__: utils_IDisposable
};
var legion_entity_Entity = function(oGame) {
	this._iIdentity = null;
	this._oGame = oGame;
	this._moAbility = new haxe_ds_StringMap();
	this.onUpdate = new trigger_eventdispatcher_EventDispatcher();
	this.onDispose = new trigger_eventdispatcher_EventDispatcher();
};
$hxClasses["legion.entity.Entity"] = legion_entity_Entity;
legion_entity_Entity.__name__ = ["legion","entity","Entity"];
legion_entity_Entity.__interfaces__ = [utils_IDisposable];
legion_entity_Entity.get_byKey = function(oGame,iKey) {
	var _g = 0;
	var _g1 = oGame.entity_get_all();
	while(_g < _g1.length) {
		var oEntity = _g1[_g];
		++_g;
		if(oEntity.key_get() == iKey) return oEntity;
	}
	return null;
};
legion_entity_Entity.prototype = {
	dispose_check: function() {
		return this._oGame == null;
	}
	,identity_get: function() {
		return this._iIdentity;
	}
	,identity_set: function(i) {
		this._iIdentity = i;
	}
	,key_get: function() {
		return this._iIdentity;
	}
	,game_get: function() {
		return this._oGame;
	}
	,ability_remove: function(oClass) {
		this._moAbility.remove(Type.getClassName(oClass));
	}
	,_ability_add: function(oAbility) {
		this._moAbility.set(Type.getClassName(oAbility == null?null:js_Boot.getClass(oAbility)),oAbility);
	}
	,ability_get: function(oClass) {
		return this._moAbility.get(Type.getClassName(oClass));
	}
	,abilityMap_get: function() {
		return this._moAbility;
	}
	,dispose: function() {
		this.onDispose.dispatch(this);
		var $it0 = this._moAbility.iterator();
		while( $it0.hasNext() ) {
			var oAbility = $it0.next();
			oAbility.dispose();
		}
		if(this._oGame != null) {
			this._oGame.entity_remove(this);
			this._oGame = null;
		}
		utils_Disposer.dispose(this);
	}
	,__class__: legion_entity_Entity
};
var legion_entity_Player = function(oGame,sName) {
	if(sName == null) sName = "Annonymous";
	legion_entity_Entity.call(this,oGame);
	this._sName = sName;
	this._oPlayerTeam = new legion_entity_PlayerTeam(oGame);
};
$hxClasses["legion.entity.Player"] = legion_entity_Player;
legion_entity_Player.__name__ = ["legion","entity","Player"];
legion_entity_Player.__super__ = legion_entity_Entity;
legion_entity_Player.prototype = $extend(legion_entity_Entity.prototype,{
	name_get: function() {
		return this._sName;
	}
	,playerId_get: function() {
		return this._iPlayerId;
	}
	,playerId_set: function(iPlayerId) {
		this._iPlayerId = iPlayerId;
	}
	,alliance_get: function(oPlayer) {
		if(this == oPlayer) return "ally";
		return "ennemy";
	}
	,__class__: legion_entity_Player
});
var legion_entity_PlayerTeam = function(oGame) {
	legion_entity_Entity.call(this,oGame);
	this._aPlayer = [];
};
$hxClasses["legion.entity.PlayerTeam"] = legion_entity_PlayerTeam;
legion_entity_PlayerTeam.__name__ = ["legion","entity","PlayerTeam"];
legion_entity_PlayerTeam.__super__ = legion_entity_Entity;
legion_entity_PlayerTeam.prototype = $extend(legion_entity_Entity.prototype,{
	player_add: function(oPlayer) {
		this._aPlayer.push(oPlayer);
	}
	,__class__: legion_entity_PlayerTeam
});
var math_Limit = function() { };
$hxClasses["math.Limit"] = math_Limit;
math_Limit.__name__ = ["math","Limit"];
var mygame_ai_Nemesis0 = function(oGame,oPlayer) {
	this._oGame = oGame;
	this._oPlayer = oPlayer;
	this._oShop = this._shop_get();
};
$hxClasses["mygame.ai.Nemesis0"] = mygame_ai_Nemesis0;
mygame_ai_Nemesis0.__name__ = ["mygame","ai","Nemesis0"];
mygame_ai_Nemesis0.prototype = {
	action_get: function() {
		var aAction = [];
		var iMoney = this._oPlayer.credit_get();
		if(iMoney > 10) aAction.push(new mygame_game_action_UnitOrderBuy(this._oShop,0));
		if(this._oGame.loopId_get() % 10 == 0) return [];
		var lIdler = this._infantryIdler_get();
		var lCity = this._oGame.query_get(mygame_game_query_UnitQuery).data_get((function($this) {
			var $r;
			var _g = new haxe_ds_StringMap();
			_g.set("type",mygame_game_entity_City);
			{
				var value = $this._oGame.player_get(0);
				_g.set("owner",value);
			}
			$r = _g;
			return $r;
		}(this)));
		lCity = utils_ListTool.merged_get(lCity,this._oGame.query_get(mygame_game_query_UnitQuery).data_get((function($this) {
			var $r;
			var _g1 = new haxe_ds_StringMap();
			_g1.set("type",mygame_game_entity_City);
			if(__map_reserved.owner != null) _g1.setReserved("owner",null); else _g1.h["owner"] = null;
			$r = _g1;
			return $r;
		}(this))));
		var _g2_head = lIdler.h;
		var _g2_val = null;
		while(_g2_head != null) {
			var oIdler;
			oIdler = (function($this) {
				var $r;
				_g2_val = _g2_head[0];
				_g2_head = _g2_head[1];
				$r = _g2_val;
				return $r;
			}(this));
			var oCity = lCity.pop();
			oIdler.ability_get(mygame_game_ability_Guidance).goal_set(oCity.ability_get(mygame_game_ability_Position));
		}
		return aAction;
	}
	,_shop_get: function() {
		var _g = 0;
		var _g1 = this._oGame.entity_get_all();
		while(_g < _g1.length) {
			var oEntity = _g1[_g];
			++_g;
			if(js_Boot.__instanceof(oEntity,mygame_game_entity_Factory) && oEntity.owner_get() == this._oPlayer) return oEntity;
		}
		throw new js__$Boot_HaxeError("Nemesis0 can not find shop");
	}
	,_infantryIdler_get: function() {
		var lIdler = new List();
		var _g1 = this._oGame.query_get(mygame_game_query_UnitQuery).data_get((function($this) {
			var $r;
			var _g = new haxe_ds_StringMap();
			_g.set("type",mygame_game_entity_PlatoonUnit);
			_g.set("owner",$this._oPlayer);
			$r = _g;
			return $r;
		}(this))).iterator();
		while(_g1.head != null) {
			var oUnit0;
			oUnit0 = (function($this) {
				var $r;
				_g1.val = _g1.head[0];
				_g1.head = _g1.head[1];
				$r = _g1.val;
				return $r;
			}(this));
			if(oUnit0.ability_get(mygame_game_ability_Guidance).goal_get() != null) continue;
			var bIsClose = false;
			var _g2 = this._oGame.query_get(mygame_game_query_UnitQuery).data_get((function($this) {
				var $r;
				var _g11 = new haxe_ds_StringMap();
				_g11.set("type",mygame_game_entity_City);
				$r = _g11;
				return $r;
			}(this))).iterator();
			while(_g2.head != null) {
				var oUnit1;
				oUnit1 = (function($this) {
					var $r;
					_g2.val = _g2.head[0];
					_g2.head = _g2.head[1];
					$r = _g2.val;
					return $r;
				}(this));
				var d = this._oGame.query_get(mygame_game_query_UnitDist).data_get([oUnit0,oUnit1]);
				if(d > 10000) continue;
				bIsClose = true;
				break;
			}
			if(!bIsClose) lIdler.add(oUnit0);
		}
		return lIdler;
	}
	,__class__: mygame_ai_Nemesis0
};
var mygame_client_MyClient = function() { };
$hxClasses["mygame.client.MyClient"] = mygame_client_MyClient;
mygame_client_MyClient.__name__ = ["mygame","client","MyClient"];
mygame_client_MyClient.main = function() {
	var oModel = new mygame_client_model_Model();
	var oView = new mygame_client_view_View(oModel);
	var oController = new mygame_client_controller_Controller(oModel,oView);
	window.haxe = { controller : oController};
};
var mygame_client_controller_Controller = function(oModel,oView) {
	this._oGameController = null;
	this._oModel = oModel;
	this._oView = oView;
	this._onButtonClick = new trigger_eventdispatcher_EventDispatcherJS("mouseup");
	this._onButtonClick.attach(this);
	this._oMenuStartNew = window.document.getElementById("BtLocalNew");
	this._oMenuOnlineNew = window.document.getElementById("BtRemoteNew");
	this._oMenuConnect = window.document.getElementById("BtConnect");
	this._oMenuRefresh = window.document.getElementById("BtRefresh");
	this._oBtShutDown = window.document.getElementById("BtShutDown");
	this._oMenuGameJoin = window.document.getElementById("BtGameJoin");
	this._oMenuGameList = window.document.getElementById("GameList");
	this._oMenuConnStatus = window.document.getElementById("LabelStatus");
};
$hxClasses["mygame.client.controller.Controller"] = mygame_client_controller_Controller;
mygame_client_controller_Controller.__name__ = ["mygame","client","controller","Controller"];
mygame_client_controller_Controller.__interfaces__ = [trigger_ITrigger];
mygame_client_controller_Controller.prototype = {
	game_start: function(oGame,iPlayerSlot,bOnline) {
		if(bOnline == null) bOnline = false;
		if(iPlayerSlot == null) iPlayerSlot = 0;
		if(oGame == null) oGame = new mygame_game_MyGame();
		this._oModel.game_set(oGame,iPlayerSlot);
		if(bOnline) this._oGameController = new mygame_client_controller_game_GameControllerOnline(this._oModel,100); else this._oGameController = new mygame_client_controller_game_GameControllerLocal(this._oModel);
	}
	,game_load: function() {
	}
	,game_save: function() {
	}
	,game_end: function() {
	}
	,gameController_get: function() {
		return this._oGameController;
	}
	,connect: function() {
		console.log("Connecting..");
		this._oModel.connection_new();
		this._oModel.connection_get().connect();
		this._oModel.connection_get().onOpen.attach(this);
		this._oModel.connection_get().onMessage.attach(this);
		this._oModel.connection_get().onClose.attach(this);
		this._oMenuConnect.innerHTML = "Loading";
		this._oMenuConnect.disabled = false;
	}
	,disconnect: function() {
		console.log("Disconnecting..");
		this._oModel.connection_get().close();
	}
	,gameList_refresh: function(oSlotList) {
		this._oMenuGameList.innerHTML = "";
		var oElement;
		var bFirst = true;
		var s;
		var _g_head = oSlotList.liGameId.h;
		var _g_val = null;
		while(_g_head != null) {
			var iGameId;
			iGameId = (function($this) {
				var $r;
				_g_val = _g_head[0];
				_g_head = _g_head[1];
				$r = _g_val;
				return $r;
			}(this));
			s = "";
			s += "<div>\n\t\t\t\t\t<input id=\"GameSelector" + iGameId + "\" type=\"radio\" name=\"GameSelector\" value=\"" + iGameId + "\"";
			if(bFirst) {
				s += "checked";
				bFirst = false;
			}
			s += ">\n\t\t\t\t<label for=\"GameSelector" + iGameId + "\">Game #" + iGameId + "</label>\n\t\t\t</div>";
			this._oMenuGameList.innerHTML += s;
		}
	}
	,join: function(iGameId) {
		if(this._oModel.connection_get() == null) {
			throw new js__$Boot_HaxeError("no connection established yet.");
			return;
		}
	}
	,trigger: function(oSource) {
		if(oSource.event_get().target == this._oMenuStartNew) {
			console.log("Starting new local game");
			this.game_start();
			return;
		}
		if(oSource.event_get().target == this._oMenuConnect) {
			if(this._oModel.connection_get() != null && this._oModel.connection_get().open_check()) this.disconnect(); else this.connect();
			return;
		}
		if(this._oModel.connection_get() != null) {
			if(oSource == this._oModel.connection_get().onOpen) {
				this._oMenuConnStatus.innerHTML = "Status : Connected.";
				this._oMenuConnect.innerHTML = "Disconnect";
				this._oMenuConnect.disabled = false;
				this._oMenuOnlineNew.disabled = false;
				this._oMenuRefresh.disabled = false;
				this._oMenuGameJoin.disabled = false;
				return;
			}
			if(oSource == this._oModel.connection_get().onClose) {
				this._oMenuConnStatus.innerHTML = "Status : Disconnected.";
				this._oMenuConnect.innerHTML = "Connect";
				this._oMenuConnect.disabled = false;
				return;
			}
			if(this._oModel.connection_get().open_check()) {
				if(oSource.event_get().target == this._oMenuRefresh) {
					console.log("Requesting slot list");
					this._oModel.connection_get().send(new mygame_connection_message_ReqSlotList());
				}
				if(oSource.event_get().target == this._oMenuGameJoin) {
					var iGameId = -1;
					var loElement = window.document.getElementsByName("GameSelector");
					var _g = 0;
					while(_g < loElement.length) {
						var oElement = loElement[_g];
						++_g;
						if((js_Boot.__cast(oElement , HTMLInputElement)).checked) {
							iGameId = Std.parseInt((js_Boot.__cast(oElement , HTMLInputElement)).value);
							break;
						}
					}
					console.log("Requesting an access to game #" + iGameId);
					this._oModel.connection_get().send(new mygame_connection_message_ReqGameJoin(iGameId));
				}
				if(oSource.event_get().target == this._oBtShutDown) this._oModel.connection_get().send(new mygame_connection_message_ReqShutDown());
				if(oSource == this._oModel.connection_get().onMessage) {
					var oMessage = this._oModel.connection_get().messageLast_get();
					if(!js_Boot.__instanceof(oMessage,mygame_connection_message_ILobbyMessage)) return;
					var _g1;
					if(oMessage == null) _g1 = null; else _g1 = js_Boot.getClass(oMessage);
					if(_g1 != null) switch(_g1) {
					case mygame_connection_message_ResGameStepInput:
						break;
					case mygame_connection_message_ResSlotList:
						console.log("slot list receive");
						this.gameList_refresh(oMessage);
						break;
					case mygame_connection_message_ResGameJoin:
						var oRespond;
						oRespond = js_Boot.__cast(oMessage , mygame_connection_message_ResGameJoin);
						console.log("[NOTICE]:game instance receive (step:" + oRespond.oGame.loopId_get() + ").");
						this.game_start(oRespond.oGame,oRespond.iSlotId,true);
						break;
					case mygame_connection_message_serversent_RoomStatus:
						console.log("[NOTICE]:updating room");
						var oRoomStatus;
						oRoomStatus = js_Boot.__cast(oMessage , mygame_connection_message_serversent_RoomStatus);
						var oRoomInfo = this._oModel.roomInfo_get();
						if(oRoomInfo == null) this._oModel.roomInfo_set(new mygame_client_model_RoomInfo(oRoomStatus)); else oRoomInfo.update(oRoomStatus);
						new mygame_client_view_MenuPause(this._oModel,window.document.getElementById("MENU-PAUSE"));
						break;
					default:
						console.log("[ERROR]:unknow command/respond from server:" + Std.string(oMessage));
					} else console.log("[ERROR]:unknow command/respond from server:" + Std.string(oMessage));
				}
			}
		}
	}
	,__class__: mygame_client_controller_Controller
};
var mygame_client_controller_game_IGameController = function() { };
$hxClasses["mygame.client.controller.game.IGameController"] = mygame_client_controller_game_IGameController;
mygame_client_controller_game_IGameController.__name__ = ["mygame","client","controller","game","IGameController"];
mygame_client_controller_game_IGameController.prototype = {
	__class__: mygame_client_controller_game_IGameController
};
var mygame_client_controller_game_GameController = function(oModel) {
	this._oModel = oModel;
	this._oGame = oModel.game_get();
	this._oGUI = oModel.GUI_get();
	this._oGameView = new mygame_client_view_GameView(this._oModel);
	this._oMouse = this._oModel.mouse_get();
	this._oKeyboard = this._oModel.keyboard_get();
	this._oStrategicZoom = new mygame_client_controller_game_StrategicZoom(this._oGameView,this._oMouse);
	this._oUnitPilot = new mygame_client_controller_game_UnitPilot(this,this._oGameView,this._oModel,this._oMouse,this._oKeyboard);
	new mygame_client_controller_game_UnitDirectControl(this,this._oModel,this._oKeyboard);
	this._oKeyboard.onUpdate.attach(this);
	new mygame_client_controller_game_UnitSelection(this,this._oGameView,this._oModel,this._oMouse,this._oKeyboard);
	new mygame_client_controller_game_Menu(this,this._oGameView,this._oModel);
};
$hxClasses["mygame.client.controller.game.GameController"] = mygame_client_controller_game_GameController;
mygame_client_controller_game_GameController.__name__ = ["mygame","client","controller","game","GameController"];
mygame_client_controller_game_GameController.__interfaces__ = [mygame_client_controller_game_IGameController,trigger_ITrigger];
mygame_client_controller_game_GameController.prototype = {
	action_add: function(oAction) {
		this._oGame.action_run(oAction);
	}
	,game_get: function() {
		return this._oGame;
	}
	,model_get: function() {
		return this._oModel;
	}
	,pause_toggle: function() {
		throw new js__$Boot_HaxeError("Abstract");
	}
	,trigger: function(oSource) {
		if(oSource == this._oKeyboard.onPress) {
			if(this._oKeyboard.keyTrigger_get() == 16) this._oGUI.mode_set(1);
		}
		if(oSource == this._oKeyboard.onRelease) {
			if(this._oKeyboard.keyTrigger_get() == 16) this._oGUI.mode_set(0);
		}
	}
	,__class__: mygame_client_controller_game_GameController
};
var mygame_client_controller_game_GameControllerLocal = function(oModel) {
	mygame_client_controller_game_GameController.call(this,oModel);
	this._oTimer = new haxe_Timer(45);
	this._oTimer.run = $bind(this,this._game_process);
	this._bPaused = false;
	this._oNemesis = new mygame_ai_Nemesis0(oModel.game_get(),this._oGame.player_get(1));
};
$hxClasses["mygame.client.controller.game.GameControllerLocal"] = mygame_client_controller_game_GameControllerLocal;
mygame_client_controller_game_GameControllerLocal.__name__ = ["mygame","client","controller","game","GameControllerLocal"];
mygame_client_controller_game_GameControllerLocal.__super__ = mygame_client_controller_game_GameController;
mygame_client_controller_game_GameControllerLocal.prototype = $extend(mygame_client_controller_game_GameController.prototype,{
	gamespeed_get: function() {
		return this._oGameSpeed;
	}
	,pause_toggle: function() {
		console.log("pausing");
		this._bPaused = !this._bPaused;
	}
	,trigger: function(oSource) {
		mygame_client_controller_game_GameController.prototype.trigger.call(this,oSource);
		if(oSource == this._oKeyboard.onUpdate) {
			if(this._oKeyboard.keyTrigger_get() == 76) {
				haxe_Serializer.USE_CACHE = true;
				mygame_connection_MySerializer._bUSE_RELATIVE = true;
				console.log(mygame_connection_MySerializer.run(this._oGame.log_get()));
			}
		}
	}
	,_game_process: function() {
		if(this._bPaused) return;
		this._oGame.loop();
		var oWinner = this._oGame.winner_get();
		if(oWinner == null) return;
		this._oTimer.stop();
		js_Lib.alert(oWinner.name_get() + "(#" + oWinner.playerId_get() + ") win the game");
	}
	,__class__: mygame_client_controller_game_GameControllerLocal
});
var mygame_client_controller_game_GameControllerOnline = function(oModel,fGameSpeed) {
	this._iDelayedLoop = 0;
	this._iLatency = 0;
	this._iTime = 0;
	mygame_client_controller_game_GameController.call(this,oModel);
	if(this._oModel.connection_get() == null) throw new js__$Boot_HaxeError("GameControllerOnline require a connection. Model is not ready.");
	this._oModel.connection_get().onMessage.attach(this);
	this._oPace = new utils_time_TimerReal(45);
	this._bUpdateReady = false;
	this._oElement = window.document.getElementById("TimeT");
	window.setInterval($bind(this,this._time_display),1000);
};
$hxClasses["mygame.client.controller.game.GameControllerOnline"] = mygame_client_controller_game_GameControllerOnline;
mygame_client_controller_game_GameControllerOnline.__name__ = ["mygame","client","controller","game","GameControllerOnline"];
mygame_client_controller_game_GameControllerOnline.__interfaces__ = [trigger_ITrigger];
mygame_client_controller_game_GameControllerOnline.__super__ = mygame_client_controller_game_GameController;
mygame_client_controller_game_GameControllerOnline.prototype = $extend(mygame_client_controller_game_GameController.prototype,{
	action_add: function(oAction) {
		console.log("sending inputs");
		this._oModel.connection_get().send(new mygame_connection_message_ReqPlayerInput(oAction));
	}
	,_game_update: function() {
		if(this._bUpdateReady && this._oPace.isExpired_get()) {
			this._game_update_force();
			this._iDelayedLoop = 0;
		} else this._iDelayedLoop++;
	}
	,_game_update_force: function() {
		this._bUpdateReady = false;
		this._oPace.reset();
		this._oGame.loop();
	}
	,_time_display: function() {
		this._oElement.innerHTML = "Latency:" + (this._iLatency - 45);
	}
	,pause_toggle: function() {
		console.log("pausing");
		this._oModel.roomInfo_get().userInfoList_get();
		this._oModel.connection_get().send(new mygame_connection_message_clientsent_ReqReadyUpdate(false));
	}
	,trigger: function(oSource) {
		mygame_client_controller_game_GameController.prototype.trigger.call(this,oSource);
		if(oSource == this._oModel.connection_get().onMessage) {
			var oMessage = this._oModel.connection_get().messageLast_get();
			if(!js_Boot.__instanceof(oMessage,mygame_connection_message_IGameMessage)) return;
			var _g;
			if(oMessage == null) _g = null; else _g = js_Boot.getClass(oMessage);
			if(_g != null) switch(_g) {
			case mygame_connection_message_ResGameStepInput:
				var oResGameStepInput;
				oResGameStepInput = js_Boot.__cast(oMessage , mygame_connection_message_ResGameStepInput);
				if(this._bUpdateReady) this._game_update_force();
				if(oResGameStepInput.loopId_get() != this._oGame.loopId_get()) {
					this._oModel.disconnect();
					console.log("[ERROR]:Invalid game step distant #" + oResGameStepInput.loopId_get() + " local #" + this._oGame.loopId_get());
					js_Lib.alert("Disconnected due to a desync.");
				}
				var _g1 = oResGameStepInput.inputList_get().iterator();
				while(_g1.head != null) {
					var oInput;
					oInput = (function($this) {
						var $r;
						_g1.val = _g1.head[0];
						_g1.head = _g1.head[1];
						$r = _g1.val;
						return $r;
					}(this));
					this._oGame.action_run(oInput);
				}
				this._iLatency = Math.floor(new Date().getTime()) - this._iTime;
				this._iTime = new Date().getTime();
				this._bUpdateReady = true;
				window.setTimeout($bind(this,this._game_update),40);
				break;
			default:
				throw new js__$Boot_HaxeError("can not process this message type : " + Type.getClassName(oMessage == null?null:js_Boot.getClass(oMessage)));
			} else throw new js__$Boot_HaxeError("can not process this message type : " + Type.getClassName(oMessage == null?null:js_Boot.getClass(oMessage)));
		}
	}
	,__class__: mygame_client_controller_game_GameControllerOnline
});
var mygame_client_controller_game_GameSpeed = function(oGame,iInterval) {
	if(iInterval == null) iInterval = 45;
	this._oGame = oGame;
	this._iInterval = iInterval;
	this.timestamp_reset();
	this._JSTimerID = window.setInterval(($_=this._oGame,$bind($_,$_.loop)),this._iInterval);
};
$hxClasses["mygame.client.controller.game.GameSpeed"] = mygame_client_controller_game_GameSpeed;
mygame_client_controller_game_GameSpeed.__name__ = ["mygame","client","controller","game","GameSpeed"];
mygame_client_controller_game_GameSpeed.prototype = {
	interpFactorPercent_get: function() {
		return (new Date().getDate() - this._iTimestamp) / this._iInterval;
	}
	,speed_set: function(iTime) {
		this._iInterval = iTime;
	}
	,speed_get: function() {
		return this._iInterval;
	}
	,timestamp_reset: function() {
		this._iTimestamp = new Date().getDate();
	}
	,__class__: mygame_client_controller_game_GameSpeed
};
var mygame_client_controller_game_Menu = function(oGameController,oGameView,oModel) {
	this._oGameController = oGameController;
	this._oGameView = oGameView;
	this._oModel = oModel;
	trigger_eventdispatcher_EventDispatcherJS.onClick.attach(this);
};
$hxClasses["mygame.client.controller.game.Menu"] = mygame_client_controller_game_Menu;
mygame_client_controller_game_Menu.__name__ = ["mygame","client","controller","game","Menu"];
mygame_client_controller_game_Menu.__interfaces__ = [trigger_ITrigger];
mygame_client_controller_game_Menu.prototype = {
	trigger: function(oSource) {
		if(oSource == trigger_eventdispatcher_EventDispatcherJS.onClick) {
			var oEvent;
			oEvent = js_Boot.__cast(oSource.event_get() , MouseEvent);
			if(!js_Boot.__instanceof(oEvent.target,HTMLButtonElement)) return;
			var oButton;
			oButton = js_Boot.__cast(oEvent.target , HTMLButtonElement);
			if(Object.prototype.hasOwnProperty.call(oButton.dataset,"sale")) this._oGameController.action_add(new mygame_game_action_UnitOrderBuy(this._oModel.GUI_get().unitSelection_get().unitList_get().first(),Std.parseInt(oButton.dataset.sale)));
		}
	}
	,__class__: mygame_client_controller_game_Menu
};
var mygame_client_controller_game_StrategicZoom = function(oGameView,oMouse) {
	this._oGameView = oGameView;
	this._oMouse = oMouse;
	this._oMouse.onWheel.attach(this);
};
$hxClasses["mygame.client.controller.game.StrategicZoom"] = mygame_client_controller_game_StrategicZoom;
mygame_client_controller_game_StrategicZoom.__name__ = ["mygame","client","controller","game","StrategicZoom"];
mygame_client_controller_game_StrategicZoom.__interfaces__ = [trigger_ITrigger];
mygame_client_controller_game_StrategicZoom.prototype = {
	move: function(oMouse) {
		var oVector = new THREE.Vector3();
		var fZoomIntensity = (mygame_client_controller_game_StrategicZoom._fMax - mygame_client_controller_game_StrategicZoom._fMin) / mygame_client_controller_game_StrategicZoom._fStepQuant;
		if(oMouse.wheel_get() > 0) {
			oVector = utils_three_Coordonate.screen_to_worldGround(oMouse.x_get(),oMouse.y_get(),this._oGameView.renderer_get(),this._oGameView.camera_get());
			oVector = oVector.sub(this._oGameView.camera_get().position);
			oVector = oVector.multiplyScalar(0.25);
			this._oGameView.camera_get().position.add(oVector);
			this._oGameView.camera_get().position.setZ(Math.max(this._oGameView.camera_get().position.z,mygame_client_controller_game_StrategicZoom._fMin));
		} else {
			oVector.set(0,0,fZoomIntensity);
			var oMatrixRotation = new THREE.Matrix4();
			oMatrixRotation.extractRotation(this._oGameView.camera_get().matrix);
			oVector = oVector.applyMatrix4(oMatrixRotation);
			this._oGameView.camera_get().position.add(oVector);
			this._oGameView.camera_get().position.setZ(Math.min(this._oGameView.camera_get().position.z,mygame_client_controller_game_StrategicZoom._fMax));
		}
	}
	,trigger: function(oSource) {
		if(oSource == this._oMouse.onWheel) this.move(oSource.event_get());
	}
	,__class__: mygame_client_controller_game_StrategicZoom
};
var mygame_client_controller_game_UnitDirectControl = function(oGameController,oModel,oKeyboard) {
	this._iDown = 83;
	this._iLeft = 81;
	this._iRight = 68;
	this._iUp = 90;
	this._oKeyboard = oKeyboard;
	this._oGameController = oGameController;
	this._oDirection = new space_Vector2i();
	this._oKeyboard.onUpdate.attach(this);
	this._bModified = false;
};
$hxClasses["mygame.client.controller.game.UnitDirectControl"] = mygame_client_controller_game_UnitDirectControl;
mygame_client_controller_game_UnitDirectControl.__name__ = ["mygame","client","controller","game","UnitDirectControl"];
mygame_client_controller_game_UnitDirectControl.__interfaces__ = [trigger_ITrigger];
mygame_client_controller_game_UnitDirectControl.prototype = {
	direction_set_X: function(x) {
		this._oDirection.x = x;
		this._bModified = true;
	}
	,direction_set_Y: function(y) {
		this._oDirection.y = y;
		this._bModified = true;
	}
	,trigger: function(oSource) {
		if(oSource == this._oKeyboard.onUpdate) {
			if(this._oKeyboard.keyTrigger_get() == this._iUp || this._oKeyboard.keyTrigger_get() == this._iDown || this._oKeyboard.keyTrigger_get() == this._iRight || this._oKeyboard.keyTrigger_get() == this._iLeft) {
				if(this._oKeyboard.keyState_get(this._iUp) == true) this.direction_set_Y(10000); else if(this._oKeyboard.keyState_get(this._iDown) == true) this.direction_set_Y(-10000); else this.direction_set_Y(0);
				if(this._oKeyboard.keyState_get(this._iRight) == true) this.direction_set_X(10000); else if(this._oKeyboard.keyState_get(this._iLeft) == true) this.direction_set_X(-10000); else this.direction_set_X(0);
				if(this._bModified) {
					this._bModified = false;
					this._oGameController.action_add(new mygame_game_action_UnitDirectControl(this._oGameController.model_get().playerLocal_get(),this._oDirection));
				}
			}
		}
	}
	,__class__: mygame_client_controller_game_UnitDirectControl
};
var mygame_client_controller_game_UnitPilot = function(oGameController,oGameView,oModel,oMouse,oKeyboard) {
	this._oGameController = oGameController;
	this._oModel = oModel;
	this._oGameView = oGameView;
	this._oMouse = oMouse;
	this._oKeyboard = oKeyboard;
	this._oMarker = new mygame_client_view_visual_Marker();
	this._oGameView.scene_get().add(this._oMarker.object3d_get());
	this._oMouse.onPressRight.attach(this);
	this._oMouse.onMove.attach(this);
};
$hxClasses["mygame.client.controller.game.UnitPilot"] = mygame_client_controller_game_UnitPilot;
mygame_client_controller_game_UnitPilot.__name__ = ["mygame","client","controller","game","UnitPilot"];
mygame_client_controller_game_UnitPilot.__interfaces__ = [trigger_ITrigger];
mygame_client_controller_game_UnitPilot.prototype = {
	tile_get: function(oMouse) {
		var oVector = new THREE.Vector3();
		oVector = utils_three_Coordonate.screen_to_worldGround(oMouse.x_get(),oMouse.y_get(),this._oGameView.renderer_get(),this._oGameView.camera_get());
		this._oGameView.scene_get().worldToLocal(oVector);
		var oMapVisual = mygame_client_view_visual_EntityVisual.get_byEntity(this._oGameController.game_get().map_get());
		return oMapVisual.tile_get_byVector(oVector);
	}
	,vector_get: function(oMouse) {
		var oVector = new THREE.Vector3();
		oVector = utils_three_Coordonate.screen_to_worldGround(oMouse.x_get(),oMouse.y_get(),this._oGameView.renderer_get(),this._oGameView.camera_get());
		this._oGameView.scene_get().worldToLocal(oVector);
		return new space_Vector2i(Math.round(oVector.x * 10000),Math.round(oVector.y * 10000));
	}
	,unit_move: function(oVector) {
		var oSelect = this._oModel.GUI_get().unitSelection_get();
		var oUnit = oSelect.unitList_get().first();
		if(oUnit == null) return;
		if(oUnit.game_get() == null) {
			oSelect.unit_remove(oUnit);
			return;
		}
		if(oUnit.ability_get(mygame_game_ability_Guidance) == null) return;
		oVector = mygame_game_ability_Mobility.positionCorrection(oUnit.ability_get(mygame_game_ability_Mobility),oVector);
		console.log("Order unit to move!");
		this._oGameController.action_add(new mygame_game_action_UnitOrderMove(oUnit,oVector));
		var oGuidance = oUnit.ability_get(mygame_game_ability_Guidance);
		if(mygame_client_view_visual_debug_PathfinderVisual.oInstance == null) new mygame_client_view_visual_debug_PathfinderVisual(this._oGameView,oGuidance.pathfinder_get()); else mygame_client_view_visual_debug_PathfinderVisual.oInstance.pathfinder_set(oGuidance.pathfinder_get());
	}
	,test: function(oMouse) {
		var oVector = new THREE.Vector3();
		oVector = utils_three_Coordonate.screen_to_worldGround(oMouse.x_get(),oMouse.y_get(),this._oGameView.renderer_get(),this._oGameView.camera_get());
		this._oGameView.scene_get().worldToLocal(oVector);
		this._oMarker.move(oVector);
	}
	,trigger: function(oSource) {
		if(oSource == this._oMouse.onPressRight) {
			var oVector = this.vector_get(oSource.event_get());
			if(oVector != null) this.unit_move(oVector);
		}
		if(oSource == this._oMouse.onMove) {
			this.test(oSource.event_get());
			var oSelect = this._oModel.GUI_get().unitSelection_get();
			var oUnit = oSelect.unitList_get().first();
			if(oUnit == null) return;
			var oPlan = oUnit.ability_get(mygame_game_ability_PositionPlan);
			if(oPlan == null) return;
			var oVector1 = this.vector_get(this._oMouse.onMove.event_get());
			var oTile = this._oModel.game_get().map_get().tile_get_byUnitMetric(oVector1.x,oVector1.y);
			if(oPlan.tile_check(oTile)) window.document.body.style.cursor = "default"; else window.document.body.style.cursor = "not-allowed";
		}
	}
	,__class__: mygame_client_controller_game_UnitPilot
};
var mygame_client_controller_game_UnitSelection = function(oGameController,oGameView,oModel,oMouse,oKeyboard) {
	this._oGameController = oGameController;
	this._oGameView = oGameView;
	this._oModel = oModel;
	this._oMouse = oMouse;
	this._oMouse.onPressRight.attach(this);
	this._oMouse.onPressLeft.attach(this);
};
$hxClasses["mygame.client.controller.game.UnitSelection"] = mygame_client_controller_game_UnitSelection;
mygame_client_controller_game_UnitSelection.__name__ = ["mygame","client","controller","game","UnitSelection"];
mygame_client_controller_game_UnitSelection.__interfaces__ = [trigger_ITrigger];
mygame_client_controller_game_UnitSelection.prototype = {
	tile_get: function(oMouse) {
		var oVector = new THREE.Vector3();
		oVector = utils_three_Coordonate.screen_to_worldGround(oMouse.x_get(),oMouse.y_get(),this._oGameView.renderer_get(),this._oGameView.camera_get());
		this._oGameView.scene_get().worldToLocal(oVector);
		var oMapVisual = mygame_client_view_visual_EntityVisual.get_byEntity(this._oGameController.game_get().map_get());
		return oMapVisual.tile_get_byVector(oVector);
	}
	,trigger: function(oSource) {
		if(oSource == this._oMouse.onPressLeft) {
			var oMouse = oSource.event_get();
			var oUnitVisual = mygame_client_view_visual_unit_UnitVisual.get_byRaycasting(oMouse.x_get(),oMouse.y_get(),this._oGameView);
			if(oUnitVisual == null) return;
			var oUnit = oUnitVisual.unit_get();
			if(oUnit == null) return;
			if(js_Boot.__instanceof(oUnit,mygame_game_entity_SubUnit)) oUnit = (js_Boot.__cast(oUnit , mygame_game_entity_SubUnit)).platoon_get();
			var oUnitSelection = this._oModel.GUI_get().unitSelection_get();
			oUnitSelection.remove_all();
			oUnitSelection.unit_add(oUnit);
		}
	}
	,__class__: mygame_client_controller_game_UnitSelection
};
var mygame_client_model_Connection = function(oModel) {
	this._bOpen = false;
	this._oWebSocket = null;
	this._oModel = oModel;
	this.onOpen = new trigger_eventdispatcher_EventDispatcher();
	this.onMessage = new trigger_eventdispatcher_EventDispatcher();
	this.onClose = new trigger_eventdispatcher_EventDispatcher();
	this._oMySerializer = new mygame_connection_MySerializer();
	this._oMySerializer.useCache = true;
	this._onUnload = new trigger_eventdispatcher_EventDispatcherJS("beforeunload");
	this._onUnload.attach(this);
};
$hxClasses["mygame.client.model.Connection"] = mygame_client_model_Connection;
mygame_client_model_Connection.__name__ = ["mygame","client","model","Connection"];
mygame_client_model_Connection.__interfaces__ = [trigger_ITrigger];
mygame_client_model_Connection.prototype = {
	open_check: function() {
		return this._bOpen;
	}
	,messageLast_get: function() {
		return this._oMessageLast;
	}
	,send: function(oMessage) {
		haxe_Serializer.USE_CACHE = true;
		if(js_Boot.__instanceof(oMessage,mygame_connection_message_ReqPlayerInput) || js_Boot.__instanceof(oMessage,mygame_connection_message_ResGameStepInput)) mygame_connection_MySerializer._bUSE_RELATIVE = true; else mygame_connection_MySerializer._bUSE_RELATIVE = false;
		this._oWebSocket.send(mygame_connection_MySerializer.run(oMessage));
	}
	,receive: function(oMessage) {
		var oMessageTmp = mygame_connection_MyUnserializer.run(oMessage.data,this._oModel.game_get());
		if(js_Boot.__instanceof(oMessageTmp,websocket_MessageComposite)) {
			var _g = 0;
			var _g1 = (js_Boot.__cast(oMessageTmp , websocket_MessageComposite)).componentArray_get();
			while(_g < _g1.length) {
				var oMessage1 = _g1[_g];
				++_g;
				this._oMessageLast = oMessage1;
				this.onMessage.dispatch(this);
			}
		}
		this._oMessageLast = oMessageTmp;
		this.onMessage.dispatch(this);
	}
	,connect: function() {
		var _g = this;
		this._oWebSocket = new WebSocket("ws://127.0.0.1:8000/server/MyServer/server.php");
		this._oWebSocket.onopen = function(t) {
			console.log("[NOTICE] : WebSocket : Connection open.");
			_g._bOpen = true;
			_g.onOpen.dispatch(_g);
		};
		this._oWebSocket.onclose = function(t1) {
			console.log("[NOTICE] : WebSocket : Connection closed by server.");
			_g._bOpen = false;
			_g.onClose.dispatch(_g);
		};
		this._oWebSocket.onmessage = $bind(this,this.receive);
		this._oWebSocket.onerror = function(t2) {
			console.log("[ERROR] : WebSocket : ");
			console.log(t2);
		};
	}
	,close: function() {
		this._oWebSocket.close();
		this._bOpen = false;
		console.log("[NOTICE] : WebSocket : Connection closed by client.");
		this.onClose.dispatch(this);
	}
	,trigger: function(oSource) {
		if(oSource == this._onUnload) this.close();
	}
	,__class__: mygame_client_model_Connection
};
var mygame_client_model_GUI = function(oGame) {
	this._oGame = null;
	this._oGame = oGame;
	this._iMode = 0;
	this._oUnitSelection = new mygame_client_model_UnitSelection(this._oGame);
	this.onModeChange = new trigger_eventdispatcher_EventDispatcher();
};
$hxClasses["mygame.client.model.GUI"] = mygame_client_model_GUI;
mygame_client_model_GUI.__name__ = ["mygame","client","model","GUI"];
mygame_client_model_GUI.prototype = {
	game_get: function() {
		return this._oGame;
	}
	,mode_get: function() {
		return this._iMode;
	}
	,mode_set: function(iMode) {
		this._iMode = iMode;
		this.onModeChange.dispatch(this);
	}
	,unitSelection_get: function() {
		return this._oUnitSelection;
	}
	,__class__: mygame_client_model_GUI
};
var mygame_client_model_Model = function() {
	this._oRoomInfo = null;
	this._oConnection = null;
	this._oGUI = null;
	this._oPlayer = null;
	this._oGame = null;
	this._oMouse = new legion_device_MegaMouse(window.document.getElementById("MyCanvas"));
	this._oKeyboard = new legion_device_Keyboard();
};
$hxClasses["mygame.client.model.Model"] = mygame_client_model_Model;
mygame_client_model_Model.__name__ = ["mygame","client","model","Model"];
mygame_client_model_Model.prototype = {
	game_get: function() {
		return this._oGame;
	}
	,playerLocal_get: function() {
		return this._oPlayer;
	}
	,GUI_get: function() {
		return this._oGUI;
	}
	,connection_get: function() {
		return this._oConnection;
	}
	,mouse_get: function() {
		return this._oMouse;
	}
	,keyboard_get: function() {
		return this._oKeyboard;
	}
	,roomInfo_get: function() {
		return this._oRoomInfo;
	}
	,game_set: function(oGame,iPlayerKey) {
		this._oGame = oGame;
		this._oPlayer = this._oGame.player_get(iPlayerKey);
		if(this._oPlayer == null) console.log("[ERROR]:invalid player id");
		this._oGUI = new mygame_client_model_GUI(this._oGame);
		return;
	}
	,roomInfo_set: function(oRoomInfo) {
		this._oRoomInfo = oRoomInfo;
	}
	,connection_new: function() {
		if(this._oConnection == null) this._oConnection = new mygame_client_model_Connection(this);
	}
	,disconnect: function() {
		console.log("Disconnecting..");
		this._oConnection.close();
	}
	,__class__: mygame_client_model_Model
};
var mygame_client_model_RoomInfo = function(oMessage) {
	this.onUpdate = new trigger_eventdispatcher_EventDispatcher();
	this.update(oMessage);
};
$hxClasses["mygame.client.model.RoomInfo"] = mygame_client_model_RoomInfo;
mygame_client_model_RoomInfo.__name__ = ["mygame","client","model","RoomInfo"];
mygame_client_model_RoomInfo.prototype = {
	userInfoList_get: function() {
		return this._aUserInfo;
	}
	,update: function(oMessage) {
		this._aUserInfo = [];
		var _g1 = 0;
		var _g = oMessage.aUser.length;
		while(_g1 < _g) {
			var i = _g1++;
			this._aUserInfo.push(new mygame_client_model_UserInfo(oMessage,i));
		}
		this.onUpdate.dispatch(this);
	}
	,__class__: mygame_client_model_RoomInfo
};
var mygame_client_model_UnitSelection = function(oGame) {
	this._oGame = null;
	this._oGame = oGame;
	this._oUnitList = new List();
	this._oUnitSelection = new haxe_ds_StringMap();
	this.onUpdate = new trigger_eventdispatcher_EventDispatcher();
};
$hxClasses["mygame.client.model.UnitSelection"] = mygame_client_model_UnitSelection;
mygame_client_model_UnitSelection.__name__ = ["mygame","client","model","UnitSelection"];
mygame_client_model_UnitSelection.prototype = {
	game_get: function() {
		return this._oGame;
	}
	,unitSelection_get: function() {
		return this._oUnitSelection;
	}
	,unit_remove: function(oUnit) {
		var sClassName = this.unitClassName_get(oUnit);
		var oUnitList = this._oUnitSelection.get(sClassName);
		if(oUnitList == null) return false;
		var res = oUnitList.remove(oUnit);
		this._oUnitList.remove(oUnit);
		this.onUpdate.dispatch(this);
		return res;
	}
	,remove_all: function() {
		var $it0 = this._oUnitSelection.iterator();
		while( $it0.hasNext() ) {
			var oUnitList = $it0.next();
			oUnitList.clear();
		}
		this._oUnitList.clear();
		this.onUpdate.dispatch(this);
	}
	,unit_add: function(oUnit) {
		var sClassName = this.unitClassName_get(oUnit);
		if(this._oUnitSelection.get(sClassName) == null) this._oUnitSelection.set(sClassName,new List());
		this._oUnitSelection.get(sClassName).add(oUnit);
		this._oUnitList.add(oUnit);
		this.onUpdate.dispatch(this);
	}
	,unitList_get: function() {
		this._update();
		return this._oUnitList;
	}
	,unitList_get_byClass: function(oClass) {
		return this._oUnitSelection.get(Type.getClassName(oClass));
	}
	,_update: function() {
		var l = new List();
		var _g_head = this._oUnitList.h;
		var _g_val = null;
		while(_g_head != null) {
			var oUnit;
			oUnit = (function($this) {
				var $r;
				_g_val = _g_head[0];
				_g_head = _g_head[1];
				$r = _g_val;
				return $r;
			}(this));
			if(!oUnit.dispose_check()) l.add(oUnit);
		}
		this._oUnitList = l;
	}
	,unitClassName_get: function(oUnit) {
		return Type.getClassName(oUnit == null?null:js_Boot.getClass(oUnit));
	}
	,__class__: mygame_client_model_UnitSelection
};
var mygame_client_model_UserInfo = function(oMessage,iIndex) {
	var msInfo = oMessage.aUser[iIndex];
	this._sName = __map_reserved.name != null?msInfo.getReserved("name"):msInfo.h["name"];
	this._bReady = __map_reserved.ready != null?msInfo.getReserved("ready"):msInfo.h["ready"];
	this._iPlayerIndex = __map_reserved.playerindex != null?msInfo.getReserved("playerindex"):msInfo.h["playerindex"];
};
$hxClasses["mygame.client.model.UserInfo"] = mygame_client_model_UserInfo;
mygame_client_model_UserInfo.__name__ = ["mygame","client","model","UserInfo"];
mygame_client_model_UserInfo.prototype = {
	ready_get: function() {
		return this._bReady;
	}
	,name_get: function() {
		return this._sName;
	}
	,playerIndex_id: function() {
		return this._iPlayerIndex;
	}
	,__class__: mygame_client_model_UserInfo
};
var mygame_client_view_GameMenu = function(oModel) {
	this._oModel = oModel;
	this._oContainer = window.document.getElementById("GameMenu");
	this._oCreditLabel = window.document.getElementById("Credit");
	this._oBuildContainer = window.document.getElementById("Build");
	this._oSelectionList = window.document.getElementById("SelectionList");
	this._oBuildList = window.document.getElementById("BuildList");
	this.credit_update();
	this.selectionList_update();
	this._oSelection = this._oModel.GUI_get().unitSelection_get();
	this._oSelection.onUpdate.attach(this);
	this._oModel.playerLocal_get().onUpdate.attach(this);
};
$hxClasses["mygame.client.view.GameMenu"] = mygame_client_view_GameMenu;
mygame_client_view_GameMenu.__name__ = ["mygame","client","view","GameMenu"];
mygame_client_view_GameMenu.__interfaces__ = [trigger_ITrigger];
mygame_client_view_GameMenu.prototype = {
	build_hide: function() {
		this._oBuildContainer.style.visibility = "hidden";
	}
	,build_show: function() {
		this._oBuildContainer.style.removeProperty("visibility");
	}
	,selectionList_update: function() {
		this._oSelectionList.innerHTML = "";
		var s = "";
		var oSelection = this._oModel.GUI_get().unitSelection_get().unitSelection_get();
		var $it0 = oSelection.keys();
		while( $it0.hasNext() ) {
			var sUnitType = $it0.next();
			if((__map_reserved[sUnitType] != null?oSelection.getReserved(sUnitType):oSelection.h[sUnitType]).length > 0) {
				s += this.pattern_selectButton(this.className_get_fromFullName(sUnitType),(__map_reserved[sUnitType] != null?oSelection.getReserved(sUnitType):oSelection.h[sUnitType]).length);
				var oBuilder = (__map_reserved[sUnitType] != null?oSelection.getReserved(sUnitType):oSelection.h[sUnitType]).first().ability_get(mygame_game_ability_BuilderFactory);
				if(oBuilder != null) {
					this.build_show();
					this.buildList_update(oBuilder);
				} else this.build_hide();
			}
		}
		this._oSelectionList.innerHTML = s;
	}
	,buildList_update: function(oBuilder) {
		this._oBuildList.innerHTML = "";
		var s = "";
		var aOffer = oBuilder.offerArray_get();
		var _g1 = 0;
		var _g = aOffer.length;
		while(_g1 < _g) {
			var iOfferId = _g1++;
			s += this.pattern_buildButton(iOfferId,aOffer[iOfferId].name_get(),aOffer[iOfferId].cost_get());
		}
		this._oBuildList.innerHTML = s;
	}
	,pattern_selectButton: function(sName,iQuantity) {
		return "<button>" + sName + "<span>" + iQuantity + "</span></button>";
	}
	,pattern_buildButton: function(iId,sName,iCost) {
		return "<button class=\"Sale\" data-sale=\"" + iId + "\">" + sName + "<span>-" + iCost + " C</span></button>";
	}
	,className_get_fromFullName: function(s) {
		var a = s.split(".");
		return a[a.length - 1];
	}
	,credit_update: function() {
		this._oCreditLabel.innerHTML = "";
		this._oCreditLabel.innerHTML = this.credit_pattern(this._oModel.playerLocal_get().credit_get());
	}
	,credit_pattern: function(iCredit) {
		return "<span>" + iCredit + "</span>";
	}
	,trigger: function(oSource) {
		if(oSource == this._oSelection.onUpdate) this.selectionList_update();
		if(oSource == this._oModel.playerLocal_get().onUpdate) this.selectionList_update();
	}
	,__class__: mygame_client_view_GameMenu
};
var mygame_client_view_GameView = function(oModel) {
	this._iLoadProgress = 0;
	var _g = this;
	this._oModel = oModel;
	this._oGame = oModel.game_get();
	this._oGUI = oModel.GUI_get();
	this.onFrame = new trigger_eventdispatcher_EventDispatcher();
	this._oOb3UpdaterManager = new ob3updater_Ob3UpdaterManager();
	this._oTextureLoader = new THREE.TextureLoader();
	this._moGeometry = new haxe_ds_StringMap();
	this._aoMaterial = new haxe_ds_StringMap();
	this._aUnitVisual = [];
	this._aPlayerColor = [];
	var oCanvas = window.document.getElementById("MyCanvas");
	this._oScene = new THREE.Scene();
	this._oScene.updateMatrix();
	this._oScene.fog = new THREE.Fog(7362808,900,1000);
	this._oSceneOrtho = new THREE.Scene();
	var w = window.innerWidth;
	var h = window.innerHeight;
	this._oCamera = new THREE.PerspectiveCamera(70,w / h,1,1000);
	this._oCamera.position.z = 50;
	this._oCamera.position.y = -30;
	this._oCamera.lookAt(new THREE.Vector3(0,0,0));
	this._oOb3UpdaterManager.add(new ob3updater_Transistion(this._oCamera,100));
	var oLightTmp = new THREE.DirectionalLight(16711122,1);
	oLightTmp.position.set(-1,-1,5);
	this._oScene.add(oLightTmp);
	var oLightTmp1 = new THREE.DirectionalLight(15724543,1.5);
	oLightTmp1.position.set(-1,-1,-1).normalize();
	this._oScene.add(oLightTmp1);
	this._oScene.add(new THREE.AmbientLight(393517));
	this._oCameraOrtho = new THREE.OrthographicCamera(-1,1,1,-1,1,1000);
	this._oCameraOrtho.position.z = 10;
	this._oRenderer = new THREE.WebGLRenderer({ canvas : oCanvas, antialias : true});
	this._oRenderer.shadowMapEnabled = true;
	this._oRenderer.setSize(w,h);
	this._oRenderer.setClearColor(new THREE.Color(7362808),1);
	this._oRenderer.autoClear = false;
	var render_update = null;
	render_update = function(f) {
		_g._oOb3UpdaterManager.process();
		_g.onFrame.dispatch(_g);
		window.requestAnimationFrame(render_update);
		_g._oRenderer.clear();
		_g._oRenderer.render(_g._oScene,_g._oCamera,null,null);
		_g._oRenderer.clearDepth();
		_g._oRenderer.render(_g._oSceneOrtho,_g._oCameraOrtho,null,null);
		return true;
	};
	render_update(0);
	window.addEventListener("resize",function(e) {
		var w1 = window.innerWidth;
		var h1 = window.innerHeight;
		_g._oCamera.aspect = w1 / h1;
		_g._oCamera.updateProjectionMatrix();
		_g._oRenderer.setSize(w1,h1);
	},false);
	this._geometry_load();
	this._material_load();
	new mygame_client_view_GameMenu(this._oModel);
};
$hxClasses["mygame.client.view.GameView"] = mygame_client_view_GameView;
mygame_client_view_GameView.__name__ = ["mygame","client","view","GameView"];
mygame_client_view_GameView.__interfaces__ = [trigger_ITrigger];
mygame_client_view_GameView.prototype = {
	update: function() {
		if(this._iLoadProgress > 0) {
			console.log("[ERROR] GameView : update : not done loading yet");
			return;
		}
		var _g = 0;
		var _g1 = this._oGame.entity_get_all();
		while(_g < _g1.length) {
			var oEntity = _g1[_g];
			++_g;
			this.entityVisual_add(oEntity);
		}
		this._oGame.onEntityNew.attach(this);
		new mygame_client_view_visual_UnitSelection(this,this._oModel);
		new mygame_client_view_visual_gui_VictoryGauge(this,this._oModel);
		new mygame_client_view_visual_gui_UnitSelectionPreview(this,this._oModel);
	}
	,entityVisual_add: function(oEntity) {
		var o = this._entityVisual_create(oEntity);
		if(o != null && o.object3d_get() != null) this._oScene.add(o.object3d_get());
	}
	,_entityVisual_create: function(oEntity) {
		if(js_Boot.__instanceof(oEntity,mygame_game_entity_WorldMap)) return new mygame_client_view_visual_MapVisual(this,oEntity);
		if(js_Boot.__instanceof(oEntity,mygame_game_entity_Unit)) {
			var oUnit = oEntity;
			var oVisual = null;
			if(js_Boot.__instanceof(oEntity,mygame_game_entity_City)) oVisual = new mygame_client_view_visual_unit_CityVisual(this,oEntity);
			if(js_Boot.__instanceof(oEntity,mygame_game_entity_Factory)) oVisual = new mygame_client_view_visual_unit_FactoryVisual(this,oEntity);
			if(js_Boot.__instanceof(oEntity,mygame_game_entity_Copter)) oVisual = new mygame_client_view_visual_unit_CopterVisual(this,oEntity);
			if(js_Boot.__instanceof(oEntity,mygame_game_entity_Bazoo)) oVisual = new mygame_client_view_visual_unit_BazooVisual(this,oEntity);
			if(js_Boot.__instanceof(oEntity,mygame_game_entity_Tank)) oVisual = new mygame_client_view_visual_unit_TankVisual(this,oEntity);
			if(js_Boot.__instanceof(oEntity,mygame_game_entity_Soldier)) oVisual = new mygame_client_view_visual_unit_SoldierVisual(this,oEntity);
			if(js_Boot.__instanceof(oEntity,mygame_game_entity_PlatoonUnit)) oVisual = new mygame_client_view_visual_unit_PlatoonVisual(this,oEntity);
			if(js_Boot.__instanceof(oEntity,mygame_game_entity_SubUnit)) oVisual = new mygame_client_view_visual_unit_SoldierVisual(this,oEntity);
			this._aUnitVisual.push(oVisual);
			var oGuidance = oUnit.ability_get(mygame_game_ability_Guidance);
			if(oGuidance != null) new mygame_client_view_visual_ability_GuidanceVisual(this,oUnit.ability_get(mygame_game_ability_Guidance));
			if(js_Boot.__instanceof(oEntity,mygame_game_entity_Tank) && oEntity.identity_get() == 11) this._oOb3UpdaterManager.add(new ob3updater_Transistion(oVisual.object3d_get(),45));
			return oVisual;
		}
		return null;
	}
	,asset_load: function(sURI,sKey) {
		var _g = this;
		this._iLoadProgress++;
		var loader = new THREE.JSONLoader();
		loader.load(sURI,(function(f,a3) {
			return function(a1,a2) {
				f(a1,a2,a3);
			};
		})(function(oGeometry,oMaterials,oDisplayer) {
			_g._iLoadProgress--;
			oDisplayer.geometry_add(oGeometry,sKey);
			if(_g._iLoadProgress == 0) _g.init();
		},this));
	}
	,material_load: function(sURI,sPosition) {
		var oTextureTmp = new THREE.TextureLoader().load(sURI);
		oTextureTmp.magFilter = THREE.NearestFilter;
		this._aoMaterial.set(sPosition,new THREE.MeshLambertMaterial({ map : oTextureTmp}));
	}
	,init: function() {
		this.update();
	}
	,model_get: function() {
		return this._oModel;
	}
	,scene_get: function() {
		return this._oScene;
	}
	,camera_get: function() {
		return this._oCamera;
	}
	,sceneOrtho_get: function() {
		return this._oSceneOrtho;
	}
	,cameraOrtho_get: function() {
		return this._oCameraOrtho;
	}
	,renderer_get: function() {
		return this._oRenderer;
	}
	,geometry_get: function(sIndex) {
		if(!this._moGeometry.exists(sIndex)) throw new js__$Boot_HaxeError("[WARNING]:trying to use unloaded ressource:" + sIndex);
		return this._moGeometry.get(sIndex);
	}
	,material_get: function(sIndex) {
		if(this._aoMaterial.get(sIndex) == null) return new THREE.MeshLambertMaterial({ });
		if(this._aoMaterial.get(sIndex) == null) throw new js__$Boot_HaxeError("!");
		return this._aoMaterial.get(sIndex);
	}
	,entityVisual_get_byEntity: function(oEntity) {
		return mygame_client_view_visual_EntityVisual.get_byEntity(oEntity);
	}
	,unitVisual_get_all: function() {
		return this._aUnitVisual;
	}
	,ob3UpdaterManager_get: function() {
		return this._oOb3UpdaterManager;
	}
	,geometry_add: function(oGeometry,sKey) {
		this._moGeometry.set(sKey,oGeometry);
	}
	,material_add: function(oMaterial,sKey) {
		this._aoMaterial.set(sKey,oMaterial);
	}
	,trigger: function(oSource) {
		if(oSource == this._oGame.onEntityNew) this.entityVisual_add(oSource.event_get());
	}
	,_materialPlayer_gen: function(sLabel,oMaterial) {
		var oMaterialTmp = null;
		oMaterialTmp = oMaterial.clone();
		oMaterialTmp.color = this._aPlayerColor[0];
		this._aoMaterial.set(sLabel + "_*",oMaterialTmp);
		var _g = 1;
		while(_g < 3) {
			var i = _g++;
			oMaterialTmp = oMaterial.clone();
			oMaterialTmp.color = this._aPlayerColor[i];
			this._aoMaterial.set(sLabel + "_" + i,oMaterialTmp);
		}
	}
	,material_get_byPlayer: function(sLabel,oPlayer) {
		if(oPlayer == null || oPlayer.playerId_get() > 2) return this.material_get(sLabel + "_*");
		return this.material_get(sLabel + "_" + (oPlayer.playerId_get() + 1));
	}
	,_geometry_load: function() {
		this.asset_load("res/gui/loyalty_gauge.js","gui_loyalty");
		this.asset_load("res/worldmap/tile_mountain.js","mountain");
		this.asset_load("res/worldmap/tile_forest.js","forest");
		this.geometry_add(new THREE.PlaneGeometry(1,1),"tile");
		this.asset_load("res/worldmap/wall.js","wall");
		this.asset_load("res/worldmap/wall_corner.js","wall_corner");
		this.asset_load("res/unit/tank_turret.js","tank_turret");
		this.asset_load("res/unit/tank_bottom.js","tank_body");
		this.asset_load("res/unit/helicopter.js","copter");
		this.asset_load("res/building/city.js","city");
		this.asset_load("res/building/factory.js","factory");
		this.asset_load("res/unit/soldier.js","soldier");
		this.asset_load("res/unit/bazooka.js","bazoo");
		this.geometry_add(new THREE.PlaneGeometry(2,2),"hud_gauge");
		this.geometry_add(new THREE.PlaneGeometry(2,2,2,2),"gui_guidancePreview");
		this.geometry_add(new THREE.RingGeometry(1,1.1,32,3),"gui_selection_circle");
	}
	,_material_load: function() {
		var o = { color : 0, depthTest : false, depthWrite : false, shading : THREE.FlatShading};
		this._aoMaterial.set("hud_gauge_bg",new THREE.MeshBasicMaterial(o));
		o.color = 1179460;
		this._aoMaterial.set("hud_gauge",new THREE.MeshBasicMaterial(o));
		o.color = 16729105;
		this._aoMaterial.set("hud_gauge_red",new THREE.MeshBasicMaterial(o));
		this._aoMaterial.set("wireframe",new THREE.MeshBasicMaterial({ color : 65535, wireframe : true, shading : THREE.NoShading}));
		this._aoMaterial.set("wireframe_white",new THREE.MeshBasicMaterial({ color : 16777215, wireframe : true, shading : THREE.NoShading}));
		this._aoMaterial.set("wireframe_grey",new THREE.MeshBasicMaterial({ color : 16755370, wireframe : true, shading : THREE.NoShading}));
		this._aoMaterial.set("wireframe_red",new THREE.MeshBasicMaterial({ color : 16711680, wireframe : true, shading : THREE.NoShading}));
		this.material_load("res/building/factory.png","factory");
		var oTextureTmp = this._oTextureLoader.load("res/texture/tile_grass.png");
		oTextureTmp.magFilter = THREE.NearestFilter;
		oTextureTmp.minFilter = THREE.NearestFilter;
		this._aoMaterial.set("tile_grass",new THREE.MeshLambertMaterial({ map : oTextureTmp}));
		console.log("Loading wolad map");
		oTextureTmp = this._oTextureLoader.load("res/texture/worldmap.png");
		oTextureTmp.magFilter = THREE.NearestFilter;
		oTextureTmp.minFilter = THREE.NearestFilter;
		this._aoMaterial.set("worldmap",new THREE.MeshBasicMaterial({ map : oTextureTmp, shading : THREE.FlatShading}));
		oTextureTmp = this._oTextureLoader.load("res/texture/worldmap.png");
		oTextureTmp.magFilter = THREE.NearestFilter;
		oTextureTmp.minFilter = THREE.NearestFilter;
		oTextureTmp.repeat.set(0.25,0.25);
		oTextureTmp.offset.set(0,0.75);
		oTextureTmp.needsUpdate = true;
		this._aoMaterial.set("tile_sea",new THREE.MeshLambertMaterial({ map : oTextureTmp}));
		oTextureTmp = this._oTextureLoader.load("res/texture/worldmap.png");
		oTextureTmp.magFilter = THREE.NearestFilter;
		oTextureTmp.minFilter = THREE.NearestFilter;
		oTextureTmp.repeat.set(0.25,0.25);
		oTextureTmp.offset.set(0.5,0.25);
		oTextureTmp.needsUpdate = true;
		this._aoMaterial.set("tile_slope",new THREE.MeshLambertMaterial({ map : oTextureTmp}));
		oTextureTmp = this._oTextureLoader.load("res/texture/worldmap.png");
		oTextureTmp.magFilter = THREE.NearestFilter;
		oTextureTmp.minFilter = THREE.NearestFilter;
		oTextureTmp.repeat.set(0.125,0.125);
		oTextureTmp.offset.set(0.625,0.5);
		oTextureTmp.needsUpdate = true;
		this._aoMaterial.set("tile_road_cross",new THREE.MeshLambertMaterial({ map : oTextureTmp}));
		oTextureTmp = this._oTextureLoader.load("res/texture/worldmap.png");
		oTextureTmp.magFilter = THREE.NearestFilter;
		oTextureTmp.minFilter = THREE.NearestFilter;
		oTextureTmp.repeat.set(0.125,0.125);
		oTextureTmp.offset.set(0.5,0.5);
		oTextureTmp.needsUpdate = true;
		this._aoMaterial.set("tile_road_WE",new THREE.MeshLambertMaterial({ map : oTextureTmp}));
		oTextureTmp = this._oTextureLoader.load("res/texture/worldmap.png");
		oTextureTmp.magFilter = THREE.NearestFilter;
		oTextureTmp.minFilter = THREE.NearestFilter;
		oTextureTmp.repeat.set(0.125,0.125);
		oTextureTmp.offset.set(0.5,0.625);
		oTextureTmp.needsUpdate = true;
		this._aoMaterial.set("tile_road_NS",new THREE.MeshLambertMaterial({ map : oTextureTmp}));
		oTextureTmp = this._oTextureLoader.load("res/texture/worldmap.png");
		oTextureTmp.magFilter = THREE.NearestFilter;
		oTextureTmp.minFilter = THREE.NearestFilter;
		oTextureTmp.repeat.set(0.125,0.125);
		oTextureTmp.offset.set(0.75,0.75);
		oTextureTmp.needsUpdate = true;
		this._aoMaterial.set("tile_road_NE",new THREE.MeshLambertMaterial({ map : oTextureTmp}));
		oTextureTmp = this._oTextureLoader.load("res/texture/worldmap.png");
		oTextureTmp.magFilter = THREE.NearestFilter;
		oTextureTmp.minFilter = THREE.NearestFilter;
		oTextureTmp.repeat.set(0.125,0.125);
		oTextureTmp.offset.set(0.75,0.875);
		oTextureTmp.needsUpdate = true;
		this._aoMaterial.set("tile_road_SE",new THREE.MeshLambertMaterial({ map : oTextureTmp}));
		oTextureTmp = this._oTextureLoader.load("res/texture/worldmap.png");
		oTextureTmp.magFilter = THREE.NearestFilter;
		oTextureTmp.minFilter = THREE.NearestFilter;
		oTextureTmp.repeat.set(0.125,0.125);
		oTextureTmp.offset.set(0.875,0.875);
		oTextureTmp.needsUpdate = true;
		this._aoMaterial.set("tile_road_SW",new THREE.MeshLambertMaterial({ map : oTextureTmp}));
		oTextureTmp = this._oTextureLoader.load("res/texture/worldmap.png");
		oTextureTmp.magFilter = THREE.NearestFilter;
		oTextureTmp.minFilter = THREE.NearestFilter;
		oTextureTmp.repeat.set(0.125,0.125);
		oTextureTmp.offset.set(0.875,0.75);
		oTextureTmp.needsUpdate = true;
		this._aoMaterial.set("tile_road_NW",new THREE.MeshLambertMaterial({ map : oTextureTmp}));
		oTextureTmp = this._oTextureLoader.load("res/texture/tree.png");
		oTextureTmp.magFilter = THREE.NearestFilter;
		oTextureTmp.minFilter = THREE.NearestFilter;
		this._aoMaterial.set("tile_forest",new THREE.MeshFaceMaterial([this.material_get("tile_grass"),new THREE.MeshBasicMaterial({ map : oTextureTmp, shading : THREE.FlatShading})]));
		var oTextureTmp1 = this._oTextureLoader.load("res/soldier.png");
		oTextureTmp1.magFilter = THREE.NearestFilter;
		oTextureTmp1.minFilter = THREE.NearestFilter;
		this._aoMaterial.set("soldier",new THREE.MeshLambertMaterial({ map : oTextureTmp1}));
		var oTextureTmp2 = this._oTextureLoader.load("res/texture/helicopter.png");
		oTextureTmp2.magFilter = THREE.NearestFilter;
		oTextureTmp2.minFilter = THREE.NearestFilter;
		this._aoMaterial.set("copter",new THREE.MeshLambertMaterial({ map : oTextureTmp2}));
		var oTextureTmp3 = this._oTextureLoader.load("res/tank_bottom.png");
		oTextureTmp3.magFilter = THREE.NearestFilter;
		oTextureTmp3.minFilter = THREE.NearestFilter;
		this._aoMaterial.set("tank",new THREE.MeshLambertMaterial({ map : oTextureTmp3}));
		var oTextureTmp4 = this._oTextureLoader.load("res/building/city.png");
		oTextureTmp4.magFilter = THREE.NearestFilter;
		oTextureTmp4.minFilter = THREE.NearestFilter;
		this._aoMaterial.set("city",new THREE.MeshLambertMaterial({ map : oTextureTmp4}));
		var oTextureTmp5 = this._oTextureLoader.load("res/building/factory.png");
		oTextureTmp5.magFilter = THREE.NearestFilter;
		oTextureTmp5.minFilter = THREE.NearestFilter;
		this._aoMaterial.set("factory",new THREE.MeshLambertMaterial({ map : oTextureTmp5, transparent : true, alphaTest : 0.1}));
		this._aoMaterial.set("wireframe",new THREE.MeshBasicMaterial({ wireframe : true, color : 16777215, wireframeLinewidth : 5, shading : THREE.NoShading}));
		this._aoMaterial.set("gui_guidancePreview",new THREE.MeshBasicMaterial({ color : 65535, wireframe : true, shading : THREE.NoShading}));
		this._aoMaterial.set("gui_guidancePreviewLine",new THREE.LineBasicMaterial({ color : 65535}));
		this._aPlayerColor[0] = new THREE.Color("white");
		this._aPlayerColor[1] = new THREE.Color("blue");
		this._aPlayerColor[2] = new THREE.Color("orange");
		this._materialPlayer_gen("player",new THREE.MeshLambertMaterial({ }));
		this._materialPlayer_gen("player_gauge",new THREE.MeshBasicMaterial({ shading : THREE.NoShading}));
		this._materialPlayer_gen("player_flat",new THREE.MeshLambertMaterial({ }));
	}
	,__class__: mygame_client_view_GameView
};
var mygame_client_view_MenuCredit = function(oModel,oDiv) {
	this._oModel = oModel;
	this._oDiv = oDiv;
	this.update();
	this._oModel.playerLocal_get().onUpdate.attach(this);
};
$hxClasses["mygame.client.view.MenuCredit"] = mygame_client_view_MenuCredit;
mygame_client_view_MenuCredit.__name__ = ["mygame","client","view","MenuCredit"];
mygame_client_view_MenuCredit.__interfaces__ = [trigger_ITrigger];
mygame_client_view_MenuCredit.prototype = {
	update: function() {
		this._oDiv.innerHTML = "";
		this._oDiv.innerHTML = this.pattern(this._oModel.playerLocal_get().credit_get());
	}
	,pattern: function(iCredit) {
		return "<span>" + iCredit + "</span>";
	}
	,trigger: function(oSource) {
		this.update();
	}
	,__class__: mygame_client_view_MenuCredit
};
var mygame_client_view_MenuPause = function(oModel,oDiv) {
	this._oModel = oModel;
	this._oDiv = oDiv;
	this._oRoomInfo = this._oModel.roomInfo_get();
	if(this._oRoomInfo == null) throw new js__$Boot_HaxeError("Invalid room info, null");
	this.update();
	this._oRoomInfo.onUpdate.attach(this);
};
$hxClasses["mygame.client.view.MenuPause"] = mygame_client_view_MenuPause;
mygame_client_view_MenuPause.__name__ = ["mygame","client","view","MenuPause"];
mygame_client_view_MenuPause.__interfaces__ = [trigger_ITrigger];
mygame_client_view_MenuPause.prototype = {
	update: function() {
		this._oDiv.innerHTML = "";
		this._oDiv.innerHTML = this.render();
	}
	,render: function() {
		var s = "<table><tbody>";
		var _g = 0;
		var _g1 = this._oRoomInfo.userInfoList_get();
		while(_g < _g1.length) {
			var oUserInfo = _g1[_g];
			++_g;
			s += "<tr><td>" + oUserInfo.name_get() + "</td>";
			s += "<td><input type=\"checkbox\" ";
			if(oUserInfo.ready_get()) s += "checked";
			s += " /></td></tr>";
		}
		s += "</tbody></table>";
		return s;
	}
	,trigger: function(oSource) {
		this.update();
	}
	,__class__: mygame_client_view_MenuPause
};
var mygame_client_view_MenuUnitSelectionView = function(oSelection,oDiv) {
	this._oSelection = oSelection;
	this._oDiv = oDiv;
	this._oSelection.onUpdate.attach(this);
	this.update();
};
$hxClasses["mygame.client.view.MenuUnitSelectionView"] = mygame_client_view_MenuUnitSelectionView;
mygame_client_view_MenuUnitSelectionView.__name__ = ["mygame","client","view","MenuUnitSelectionView"];
mygame_client_view_MenuUnitSelectionView.__interfaces__ = [trigger_ITrigger];
mygame_client_view_MenuUnitSelectionView.prototype = {
	update: function() {
		this._oDiv.innerHTML = "";
		var s = "";
		var oSelection = this._oSelection.unitSelection_get();
		var $it0 = oSelection.keys();
		while( $it0.hasNext() ) {
			var sUnitType = $it0.next();
			if((__map_reserved[sUnitType] != null?oSelection.getReserved(sUnitType):oSelection.h[sUnitType]).length > 0) {
				s += this.pattern(this.className_get_fromFullName(sUnitType),(__map_reserved[sUnitType] != null?oSelection.getReserved(sUnitType):oSelection.h[sUnitType]).length);
				var oBuilder = (__map_reserved[sUnitType] != null?oSelection.getReserved(sUnitType):oSelection.h[sUnitType]).first().ability_get(mygame_game_ability_BuilderFactory);
				if(oBuilder != null) {
					var aOffer = oBuilder.offerArray_get();
					var _g1 = 0;
					var _g = aOffer.length;
					while(_g1 < _g) {
						var iOfferId = _g1++;
						s += this.pattern_builder(iOfferId,aOffer[iOfferId].name_get(),aOffer[iOfferId].cost_get());
					}
				}
			}
		}
		this._oDiv.innerHTML = s;
	}
	,pattern: function(sName,iQuantity) {
		return "<button>" + sName + "<span>" + iQuantity + "</span></button>";
	}
	,pattern_builder: function(iId,sName,iCost) {
		return "<button class=\"Sale\" data-sale=\"" + iId + "\">" + sName + "<span>-" + iCost + " C</span></button>";
	}
	,className_get_fromFullName: function(s) {
		var a = s.split(".");
		return a[a.length - 1];
	}
	,trigger: function(oSource) {
		if(oSource == this._oSelection.onUpdate) this.update();
	}
	,__class__: mygame_client_view_MenuUnitSelectionView
};
var mygame_client_view_View = function(oModel) {
	this._oMenuPause = null;
	this._oGameView = null;
	this._oModel = oModel;
};
$hxClasses["mygame.client.view.View"] = mygame_client_view_View;
mygame_client_view_View.__name__ = ["mygame","client","view","View"];
mygame_client_view_View.__interfaces__ = [trigger_ITrigger];
mygame_client_view_View.prototype = {
	update: function() {
	}
	,trigger: function(oSource) {
	}
	,__class__: mygame_client_view_View
};
var ob3updater_IOb3Updater = function() { };
$hxClasses["ob3updater.IOb3Updater"] = ob3updater_IOb3Updater;
ob3updater_IOb3Updater.__name__ = ["ob3updater","IOb3Updater"];
ob3updater_IOb3Updater.prototype = {
	__class__: ob3updater_IOb3Updater
};
var mygame_client_view_ob3updater_Follow = function(oGameView,oObject3D,oObject3DFollowed) {
	this._oObject3D = oObject3D;
	this._oObject3D.matrixAutoUpdate = false;
	this._oObject3DFollowed = oObject3DFollowed;
	this._oGameView = oGameView;
};
$hxClasses["mygame.client.view.ob3updater.Follow"] = mygame_client_view_ob3updater_Follow;
mygame_client_view_ob3updater_Follow.__name__ = ["mygame","client","view","ob3updater","Follow"];
mygame_client_view_ob3updater_Follow.__interfaces__ = [ob3updater_IOb3Updater];
mygame_client_view_ob3updater_Follow.prototype = {
	object3d_get: function() {
		return this._oObject3D;
	}
	,gameView_get: function() {
		return this._oGameView;
	}
	,update: function() {
		var oMatrix = this._orthoproject(this._oObject3DFollowed);
		var v = new THREE.Vector3(0,0);
		var vDelta = new THREE.Vector3(1,1);
		v.applyProjection(oMatrix);
		vDelta.applyProjection(oMatrix);
		var oMatrixUpdated = new THREE.Matrix4();
		oMatrixUpdated.compose(new THREE.Vector3(v.x,v.y,0),new THREE.Quaternion(),new THREE.Vector3(vDelta.x - v.x,Math.max(Math.min(vDelta.y - v.y,0.01),0.002),1));
		this._oObject3D.matrix = oMatrixUpdated;
		this._oObject3D.matrixWorldNeedsUpdate = true;
	}
	,_orthoproject: function(oObj) {
		var oCamera = this.gameView_get().camera_get();
		var oCameraOrtho = this.gameView_get().cameraOrtho_get();
		var up = oObj;
		while(up.parent != null && up.parent.matrixWorldNeedsUpdate == true) up = up.parent;
		up.updateMatrixWorld(true);
		var oObjMatrixWorld = oObj.matrixWorld;
		oCamera.updateMatrixWorld(true);
		oCamera.matrixWorldInverse.getInverse(oCamera.matrixWorld);
		var oMatrix = new THREE.Matrix4();
		oMatrix.multiplyMatrices(oCamera.matrixWorldInverse,oObjMatrixWorld);
		oMatrix.multiplyMatrices(oCamera.projectionMatrix,oMatrix);
		return oMatrix;
	}
	,__class__: mygame_client_view_ob3updater_Follow
};
var mygame_client_view_visual_IVisual = function() { };
$hxClasses["mygame.client.view.visual.IVisual"] = mygame_client_view_visual_IVisual;
mygame_client_view_visual_IVisual.__name__ = ["mygame","client","view","visual","IVisual"];
mygame_client_view_visual_IVisual.prototype = {
	__class__: mygame_client_view_visual_IVisual
};
var mygame_client_view_visual_EntityVisual = function(oEntity) {
	this._oEntity = oEntity;
	mygame_client_view_visual_EntityVisual._moEntityVisual.set(this._oEntity.identity_get(),this);
	this._oEntity.onDispose.attach(this);
};
$hxClasses["mygame.client.view.visual.EntityVisual"] = mygame_client_view_visual_EntityVisual;
mygame_client_view_visual_EntityVisual.__name__ = ["mygame","client","view","visual","EntityVisual"];
mygame_client_view_visual_EntityVisual.__interfaces__ = [trigger_ITrigger,mygame_client_view_visual_IVisual];
mygame_client_view_visual_EntityVisual.get_all = function() {
	return mygame_client_view_visual_EntityVisual._moEntityVisual;
};
mygame_client_view_visual_EntityVisual.get_byEntity = function(oEntity) {
	return mygame_client_view_visual_EntityVisual._moEntityVisual.get(oEntity.identity_get());
};
mygame_client_view_visual_EntityVisual.prototype = {
	object3d_get: function() {
		throw new js__$Boot_HaxeError("EntityVisual.object3d_get is abstract, override me ");
		return null;
	}
	,update: function() {
		throw new js__$Boot_HaxeError("EntityVisual.update is abstract, override me ");
		null;
		return;
	}
	,trigger: function(oSource) {
		if(oSource == this._oEntity.onDispose) this.dispose();
	}
	,dispose: function() {
		if(this.object3d_get() != null) this.object3d_get().parent.remove(this.object3d_get());
		mygame_client_view_visual_EntityVisual._moEntityVisual.remove(this._oEntity.identity_get());
		utils_Disposer.dispose(this);
	}
	,__class__: mygame_client_view_visual_EntityVisual
};
var mygame_client_view_visual_IEntityVisual = function() { };
$hxClasses["mygame.client.view.visual.IEntityVisual"] = mygame_client_view_visual_IEntityVisual;
mygame_client_view_visual_IEntityVisual.__name__ = ["mygame","client","view","visual","IEntityVisual"];
mygame_client_view_visual_IEntityVisual.__interfaces__ = [mygame_client_view_visual_IVisual];
mygame_client_view_visual_IEntityVisual.prototype = {
	__class__: mygame_client_view_visual_IEntityVisual
};
var mygame_client_view_visual_MapVisual = function(oDisplayer,oMap) {
	mygame_client_view_visual_EntityVisual.call(this,oMap);
	this._oScene = new THREE.Group();
	this._oMap = oMap;
	this._oView = oDisplayer;
	var oTileTmp = null;
	var _g1 = 0;
	var _g = this._oMap.sizeX_get();
	while(_g1 < _g) {
		var i = _g1++;
		var _g3 = 0;
		var _g2 = this._oMap.sizeY_get();
		while(_g3 < _g2) {
			var j = _g3++;
			oTileTmp = this._oMap.tile_get(i,j);
			var oMesh = new THREE.Mesh(this.geometry_get_byTile(oTileTmp),this.material_get_byTile(oTileTmp));
			oMesh.position.set(i + 0.5,j + 0.5,oTileTmp.z_get() / 8);
			oMesh.receiveShadow = true;
			oMesh.castShadow = true;
			this._oScene.add(oMesh);
			var oDelta = new THREE.Vector2();
			var _g4 = oTileTmp.neighborList_get().iterator();
			while(_g4.head != null) {
				var oNeighbor1;
				oNeighbor1 = (function($this) {
					var $r;
					_g4.val = _g4.head[0];
					_g4.head = _g4.head[1];
					$r = _g4.val;
					return $r;
				}(this));
				if(oTileTmp.z_get() - oNeighbor1.z_get() == 2) {
					oDelta.set(oNeighbor1.x_get() - oTileTmp.x_get(),oNeighbor1.y_get() - oTileTmp.y_get());
					var fAngle = Math.atan2(oDelta.y,oDelta.x);
					var oWallMesh = new THREE.Mesh(this._oView.geometry_get("wall"),this._oView.material_get("tile_slope"));
					oWallMesh.rotation.z = fAngle;
					oWallMesh.receiveShadow = true;
					oWallMesh.castShadow = true;
					oMesh.add(oWallMesh);
				}
			}
			var oNeighbor = null;
			var _g41 = 0;
			while(_g41 < 4) {
				var i1 = _g41++;
				switch(i1) {
				case 0:
					oNeighbor = this._oMap.tile_get(oTileTmp.x_get() + 1,oTileTmp.y_get() + 1);
					break;
				case 1:
					oNeighbor = this._oMap.tile_get(oTileTmp.x_get() - 1,oTileTmp.y_get() + 1);
					break;
				case 2:
					oNeighbor = this._oMap.tile_get(oTileTmp.x_get() + 1,oTileTmp.y_get() - 1);
					break;
				case 3:
					oNeighbor = this._oMap.tile_get(oTileTmp.x_get() - 1,oTileTmp.y_get() - 1);
					break;
				}
				if(oNeighbor != null && oTileTmp.z_get() - oNeighbor.z_get() == 2) {
					var fAngle1 = 0;
					switch(i1) {
					case 0:
						fAngle1 = 180;
						break;
					case 1:
						fAngle1 = 90;
						break;
					case 3:
						fAngle1 = -90;
						break;
					}
					oDelta.set(oNeighbor.x_get() - oTileTmp.x_get(),oNeighbor.y_get() - oTileTmp.y_get());
					var fAngle2 = Math.atan2(oDelta.y,oDelta.x) + Math.PI / 4;
					var oWallMesh1 = new THREE.Mesh(this._oView.geometry_get("wall_corner"),this._oView.material_get("tile_slope"));
					oWallMesh1.rotation.z = fAngle2;
					oWallMesh1.receiveShadow = true;
					oWallMesh1.castShadow = true;
					oMesh.add(oWallMesh1);
				}
			}
		}
	}
	this._oScene.updateMatrix();
	this._oScene.receiveShadow = true;
	this._oScene.castShadow = true;
	this.update();
};
$hxClasses["mygame.client.view.visual.MapVisual"] = mygame_client_view_visual_MapVisual;
mygame_client_view_visual_MapVisual.__name__ = ["mygame","client","view","visual","MapVisual"];
mygame_client_view_visual_MapVisual.__super__ = mygame_client_view_visual_EntityVisual;
mygame_client_view_visual_MapVisual.prototype = $extend(mygame_client_view_visual_EntityVisual.prototype,{
	map_get: function() {
		return this._oMap;
	}
	,object3d_get: function() {
		return this._oScene;
	}
	,tile_get_byVector: function(oVector) {
		return this._oMap.tile_get(oVector.x | 0,oVector.y | 0);
	}
	,height_get: function(x,y) {
		var oTile = this._oMap.tile_get_byUnitMetric(x,y);
		var _g = oTile.type_get();
		switch(_g) {
		case 3:
			x %= 1;
			y %= 1;
			var xd = x - 0.5;
			var yd = y - 0.5;
			return 0.25 + Math.max(0,0.5 - Math.sqrt(xd * xd + yd * yd));
		}
		if(this._oEntity.game_get().query_get(mygame_game_query_CityTile).data_get(oTile).length != 0) return 1;
		return 0.25;
	}
	,update: function() {
	}
	,geometry_get_byTile: function(oTile) {
		if(oTile.type_get() == 3) return this._oView.geometry_get("mountain");
		if(oTile.type_get() == 2) return this._oView.geometry_get("forest");
		return this._oView.geometry_get("tile");
	}
	,material_get_byTile: function(oTile) {
		if(oTile.type_get() == 4) {
			var i = 0;
			var oMap = oTile.map_get();
			if(oMap.tile_get(oTile.x_get(),oTile.y_get() + 1).type_get() == 4) i += 1;
			if(oMap.tile_get(oTile.x_get() + 1,oTile.y_get()).type_get() == 4) i += 2;
			if(oMap.tile_get(oTile.x_get(),oTile.y_get() - 1).type_get() == 4) i += 4;
			if(oMap.tile_get(oTile.x_get() - 1,oTile.y_get()).type_get() == 4) i += 8;
			switch(i) {
			case 5:
				return this._oView.material_get("tile_road_NS");
			case 10:
				return this._oView.material_get("tile_road_WE");
			case 3:
				return this._oView.material_get("tile_road_NE");
			case 6:
				return this._oView.material_get("tile_road_SE");
			case 12:
				return this._oView.material_get("tile_road_SW");
			case 9:
				return this._oView.material_get("tile_road_NW");
			}
			return this._oView.material_get("tile_road_cross");
		}
		if(oTile.type_get() == 3) return this._oView.material_get("worldmap");
		if(oTile.type_get() == 2) return this._oView.material_get("tile_forest");
		if(oTile.type_get() == 1) return this._oView.material_get("tile_grass");
		return this._oView.material_get("tile_sea");
	}
	,__class__: mygame_client_view_visual_MapVisual
});
var mygame_client_view_visual_Marker = function() {
	this._oMesh = new THREE.Mesh(new THREE.CircleGeometry(1,32),new THREE.MeshBasicMaterial({ color : 16733525, wireframe : false, opacity : 0.5, transparent : true}));
	this._oMesh.scale.set(0.5,0.5,0.5);
	this._oMesh.position.set(0,0,0);
	this._oMesh.castShadow = true;
	this._oMesh.receiveShadow = true;
	this._oDiv = window.document.getElementById("MouseXY");
};
$hxClasses["mygame.client.view.visual.Marker"] = mygame_client_view_visual_Marker;
mygame_client_view_visual_Marker.__name__ = ["mygame","client","view","visual","Marker"];
mygame_client_view_visual_Marker.__interfaces__ = [mygame_client_view_visual_IVisual];
mygame_client_view_visual_Marker.prototype = {
	move: function(oVector) {
		this._oMesh.position.setX(oVector.x);
		this._oMesh.position.setY(oVector.y);
		this._oMesh.position.setZ(oVector.z);
		var v = this._oMesh.localToWorld(new THREE.Vector3(0,0,0));
		this._oDiv.innerHTML = "[" + v.x + ";" + v.y + "]";
	}
	,update: function() {
	}
	,object3d_get: function() {
		return this._oMesh;
	}
	,__class__: mygame_client_view_visual_Marker
};
var mygame_client_view_visual_UnitSelection = function(oGameView,oModel) {
	this._oGameView = oGameView;
	this._oModel = oModel;
	this._oSelection = oModel.GUI_get().unitSelection_get();
	this._loVisual = new List();
	this._update_circle();
	this._oUnitVisualSelectionPreview = null;
	this._bUpdateNeeded = false;
	this._oGuidancePreview = new THREE.Mesh(this._oGameView.geometry_get("gui_guidancePreview"),this._oGameView.material_get("gui_guidancePreview"));
	this._oGuidancePreview.position.set(0,0,0);
	this._oGuidancePreview.receiveShadow = true;
	this._oGuidancePreview.visible = false;
	oGameView.scene_get().add(this._oGuidancePreview);
	var oGeometry = new THREE.Geometry();
	oGeometry.vertices.push(new THREE.Vector3(0,0,0));
	oGeometry.vertices.push(new THREE.Vector3(-10,-10,0));
	this._oGuidancePreviewLine = new THREE.Line(oGeometry,this._oGameView.material_get("gui_guidancePreviewLine"));
	oGameView.scene_get().add(this._oGuidancePreviewLine);
	this._oSelection.onUpdate.attach(this);
	this._oModel.mouse_get().onMove.attach(this);
	this._oModel.game_get().onLoopEnd.attach(this);
	this._oGameView.onFrame.attach(this);
};
$hxClasses["mygame.client.view.visual.UnitSelection"] = mygame_client_view_visual_UnitSelection;
mygame_client_view_visual_UnitSelection.__name__ = ["mygame","client","view","visual","UnitSelection"];
mygame_client_view_visual_UnitSelection.__interfaces__ = [trigger_ITrigger,mygame_client_view_visual_IVisual];
mygame_client_view_visual_UnitSelection.prototype = {
	object3d_get: function() {
		return null;
	}
	,_update_circle: function() {
		var _g_head = this._loVisual.h;
		var _g_val = null;
		while(_g_head != null) {
			var oVisual;
			oVisual = (function($this) {
				var $r;
				_g_val = _g_head[0];
				_g_head = _g_head[1];
				$r = _g_val;
				return $r;
			}(this));
			if(oVisual.gameView_get() != null) {
				oVisual.selection_set(false);
				oVisual.rangeVisualVisibility_set(false);
			}
		}
		this._loVisual.clear();
		var oSelection = this._oSelection.unitSelection_get();
		var $it0 = oSelection.keys();
		while( $it0.hasNext() ) {
			var sUnitType = $it0.next();
			var _g = (__map_reserved[sUnitType] != null?oSelection.getReserved(sUnitType):oSelection.h[sUnitType]).iterator();
			while(_g.head != null) {
				var oUnit;
				oUnit = (function($this) {
					var $r;
					_g.val = _g.head[0];
					_g.head = _g.head[1];
					$r = _g.val;
					return $r;
				}(this));
				var oVisual1 = mygame_client_view_visual_EntityVisual.get_byEntity(oUnit);
				oVisual1.selection_set(true);
				oVisual1.rangeVisualVisibility_set(true);
				this._loVisual.add(oVisual1);
				var oPlatoon = oUnit.ability_get(mygame_game_ability_Platoon);
				if(oPlatoon != null) {
					var _g1 = 0;
					var _g11 = oPlatoon.subUnit_get();
					while(_g1 < _g11.length) {
						var oSubUnit = _g11[_g1];
						++_g1;
						var oVisual2 = mygame_client_view_visual_EntityVisual.get_byEntity(oSubUnit);
						oVisual2.selection_set(true);
						oVisual2.rangeVisualVisibility_set(true);
						this._loVisual.add(oVisual2);
					}
				}
			}
		}
	}
	,_destinationPreview_update: function() {
		if(!this._bUpdateNeeded) return;
		var oSelect = this._oModel.GUI_get().unitSelection_get();
		var oUnit = oSelect.unitList_get().first();
		if(oUnit == null) return;
		var oGuidance = oUnit.ability_get(mygame_game_ability_Guidance);
		if(oGuidance == null) {
			this._oGuidancePreview.visible = false;
			this._oGuidancePreviewLine.visible = false;
			return;
		}
		var oVector;
		oVector = utils_three_Coordonate.screen_to_worldGround(this._oModel.mouse_get().x_get(),this._oModel.mouse_get().y_get(),this._oGameView.renderer_get(),this._oGameView.camera_get());
		oVector = new space_Vector2i(Math.round(oVector.x * 10000),Math.round(oVector.y * 10000));
		oVector = mygame_game_ability_Mobility.positionCorrection(oGuidance.mobility_get(),oVector);
		oVector = mygame_game_ability_Position.metric_unit_to_map_vector(oVector);
		var oVolume = oUnit.ability_get(mygame_game_ability_Volume);
		if(oVolume != null) {
			var i = mygame_game_ability_Position.metric_unit_to_map(oVolume.size_get());
			this._oGuidancePreview.position.set(oVector.x,oVector.y,0.5);
			this._oGuidancePreview.scale.set(i,i,i);
		}
		if(oVector == null) return;
		var oVisual = mygame_client_view_visual_EntityVisual.get_byEntity(oUnit);
		var oPosition = oVisual.object3d_get().position;
		var scene = this._oGuidancePreviewLine.parent;
		scene.remove(this._oGuidancePreviewLine);
		var oGeometry = new THREE.Geometry();
		oGeometry.vertices.push(new THREE.Vector3(oVector.x,oVector.y,0.5));
		oGeometry.vertices.push(new THREE.Vector3(oPosition.x,oPosition.y,0.5));
		this._oGuidancePreviewLine = new THREE.Line(oGeometry,this._oGameView.material_get("gui_guidancePreviewLine"));
		scene.add(this._oGuidancePreviewLine);
		this._oGuidancePreview.visible = true;
		this._oGuidancePreviewLine.visible = true;
	}
	,trigger: function(oSource) {
		if(oSource == this._oSelection.onUpdate) this._update_circle();
		if(oSource == this._oModel.game_get().onLoopEnd || oSource == this._oModel.mouse_get().onMove) this._bUpdateNeeded = true;
		if(oSource == this._oGameView.onFrame) this._destinationPreview_update();
	}
	,__class__: mygame_client_view_visual_UnitSelection
};
var mygame_client_view_visual_ability_GuidanceVisual = function(oGameView,oGuidance) {
	this._oLine = null;
	this._oGameView = oGameView;
	this._oGuidance = oGuidance;
	this._oLine = new THREE.Line(new THREE.Geometry(),mygame_client_view_visual_ability_GuidanceVisual._oMaterial);
	this._oGameView.scene_get().add(this.object3d_get());
	this.update();
	this._oGameView.model_get().game_get().onLoopEnd.attach(this);
};
$hxClasses["mygame.client.view.visual.ability.GuidanceVisual"] = mygame_client_view_visual_ability_GuidanceVisual;
mygame_client_view_visual_ability_GuidanceVisual.__name__ = ["mygame","client","view","visual","ability","GuidanceVisual"];
mygame_client_view_visual_ability_GuidanceVisual.__interfaces__ = [trigger_ITrigger,mygame_client_view_visual_IVisual];
mygame_client_view_visual_ability_GuidanceVisual.prototype = {
	object3d_get: function() {
		return this._oLine;
	}
	,update: function() {
		if(this._oGuidance.goal_get() == null) {
			if(this._oLine == null) return; else this._oLine.visible = false;
		}
		var geometry = new THREE.Geometry();
		var destination = this._oGuidance.goal_get();
		if(destination != null) {
			var oPosition = this._oGuidance.mobility_get().position_get();
			geometry.vertices.push(new THREE.Vector3(mygame_game_ability_Position.metric_unit_to_map(destination.x),mygame_game_ability_Position.metric_unit_to_map(destination.y),0.51));
			geometry.vertices.push(new THREE.Vector3(mygame_game_ability_Position.metric_unit_to_map(oPosition.x),mygame_game_ability_Position.metric_unit_to_map(oPosition.y),0.51));
		}
		var scene = this._oLine.parent;
		scene.remove(this._oLine);
		this._oLine = new THREE.Line(geometry,mygame_client_view_visual_ability_GuidanceVisual._oMaterial);
		scene.add(this._oLine);
	}
	,_update: function() {
	}
	,trigger: function(oSource) {
		if(oSource == this._oGameView.model_get().game_get().onLoopEnd) this.update();
	}
	,__class__: mygame_client_view_visual_ability_GuidanceVisual
};
var mygame_client_view_visual_ability_UnitAbilityVisual = function(oAbility) {
	this._bDisposed = false;
	this._oAbility = oAbility;
	this._oOrigin = new THREE.Object3D();
	this._oAbility.onDispose.attach(this);
};
$hxClasses["mygame.client.view.visual.ability.UnitAbilityVisual"] = mygame_client_view_visual_ability_UnitAbilityVisual;
mygame_client_view_visual_ability_UnitAbilityVisual.__name__ = ["mygame","client","view","visual","ability","UnitAbilityVisual"];
mygame_client_view_visual_ability_UnitAbilityVisual.__interfaces__ = [trigger_ITrigger,mygame_client_view_visual_IVisual];
mygame_client_view_visual_ability_UnitAbilityVisual.prototype = {
	object3d_get: function() {
		return this._oOrigin;
	}
	,trigger: function(oSource) {
		if(oSource == this._oAbility.onDispose) this.dispose();
	}
	,dispose: function() {
		if(this._oOrigin.parent != null) this._oOrigin.parent.remove(this._oOrigin);
		utils_Disposer.dispose(this);
		this._bDisposed = true;
	}
	,__class__: mygame_client_view_visual_ability_UnitAbilityVisual
};
var mygame_client_view_visual_ability_WeaponVisual = function(oUnitVisual,oWeapon,oGUI) {
	this._oLine = null;
	mygame_client_view_visual_ability_UnitAbilityVisual.call(this,oWeapon);
	this._oUnitVisual = oUnitVisual;
	this._oGameView = this._oUnitVisual.gameView_get();
	this._oAbility = oWeapon;
	this._oGUI = oGUI;
	this.update();
	this._oGameView.model_get().game_get().oWeaponProcess.onTargeting.attach(this);
	this._oAbility.onFire.attach(this);
};
$hxClasses["mygame.client.view.visual.ability.WeaponVisual"] = mygame_client_view_visual_ability_WeaponVisual;
mygame_client_view_visual_ability_WeaponVisual.__name__ = ["mygame","client","view","visual","ability","WeaponVisual"];
mygame_client_view_visual_ability_WeaponVisual.__interfaces__ = [trigger_ITrigger,mygame_client_view_visual_IVisual];
mygame_client_view_visual_ability_WeaponVisual.__super__ = mygame_client_view_visual_ability_UnitAbilityVisual;
mygame_client_view_visual_ability_WeaponVisual.prototype = $extend(mygame_client_view_visual_ability_UnitAbilityVisual.prototype,{
	update: function() {
		if(this._oAbility.target_get() != null && this._oLine == null) {
			var oTargetVisual = mygame_client_view_visual_EntityVisual.get_byEntity(this._oAbility.target_get());
			if(oTargetVisual != null) {
				var geometry = new THREE.Geometry();
				geometry.vertices.push(new THREE.Vector3(0,0.1,0));
				geometry.vertices.push(new THREE.Vector3(0,0,0));
				this._oLine = new THREE.Line(geometry,mygame_client_view_visual_ability_WeaponVisual._oMaterial);
				this._oUnitVisual.object3d_get().add(this._oLine);
			}
		} else if(this._oAbility.target_get() == null && this._oLine != null) {
			this._oUnitVisual.object3d_get().remove(this._oLine);
			this._oLine = null;
		}
		if(this._oLine != null) {
			var oTargetVisual1 = mygame_client_view_visual_EntityVisual.get_byEntity(this._oAbility.target_get());
			var v = this._oUnitVisual.object3d_get().worldToLocal(oTargetVisual1.object3d_get().localToWorld(new THREE.Vector3(0,0,0)));
			this._oLine.geometry.verticesNeedUpdate = true;
			this._oLine.geometry.vertices[1] = v;
			this._oLine.updateMatrix();
			if(this._oAbility.cooldown_get().expirePercent_get() > 0.5) this._oLine.visible = false;
		}
	}
	,update_visibility: function() {
		if(this._oGUI.mode_get() == 0) this.hide(); else this.show();
	}
	,hide: function() {
		console.log(this._oSprite.material.visible);
		mygame_client_view_visual_ability_WeaponVisual._oMatBackground.visible = false;
		mygame_client_view_visual_ability_WeaponVisual._oMatForeground.visible = false;
	}
	,show: function() {
		console.log(this._oSprite.material.visible);
		mygame_client_view_visual_ability_WeaponVisual._oMatBackground.visible = true;
		mygame_client_view_visual_ability_WeaponVisual._oMatForeground.visible = true;
	}
	,trigger: function(oSource) {
		if(oSource == this._oGameView.model_get().game_get().oWeaponProcess.onTargeting) this.update();
		if(oSource == this._oAbility.onFire) {
			if(this._oLine != null) this._oLine.visible = true;
		}
		mygame_client_view_visual_ability_UnitAbilityVisual.prototype.trigger.call(this,oSource);
	}
	,dispose: function() {
		this._oGameView.model_get().game_get().oWeaponProcess.onTargeting.remove(this);
		mygame_client_view_visual_ability_UnitAbilityVisual.prototype.dispose.call(this);
	}
	,__class__: mygame_client_view_visual_ability_WeaponVisual
});
var mygame_client_view_visual_debug_Boxy = function(oGameView) {
	this._oMesh = null;
	this._oGameView = oGameView;
	this._oMesh = new THREE.Mesh(this._oGameView.geometry_get("gui_guidancePreview"),this._oGameView.material_get("gui_guidancePreview"));
	mygame_client_view_visual_debug_Boxy.oInstance = this;
	this._oGameView.scene_get().add(this.object3d_get());
};
$hxClasses["mygame.client.view.visual.debug.Boxy"] = mygame_client_view_visual_debug_Boxy;
mygame_client_view_visual_debug_Boxy.__name__ = ["mygame","client","view","visual","debug","Boxy"];
mygame_client_view_visual_debug_Boxy.__interfaces__ = [mygame_client_view_visual_IVisual];
mygame_client_view_visual_debug_Boxy.prototype = {
	object3d_get: function() {
		return this._oMesh;
	}
	,__class__: mygame_client_view_visual_debug_Boxy
};
var mygame_client_view_visual_debug_PathfinderVisual = function(oGameView,oPathfinder) {
	this._oLine = null;
	this._oGameView = oGameView;
	this._oPathfinder = oPathfinder;
	this.update();
	mygame_client_view_visual_debug_PathfinderVisual.oInstance = this;
	this._oGameView.scene_get().add(this.object3d_get());
};
$hxClasses["mygame.client.view.visual.debug.PathfinderVisual"] = mygame_client_view_visual_debug_PathfinderVisual;
mygame_client_view_visual_debug_PathfinderVisual.__name__ = ["mygame","client","view","visual","debug","PathfinderVisual"];
mygame_client_view_visual_debug_PathfinderVisual.__interfaces__ = [mygame_client_view_visual_IVisual];
mygame_client_view_visual_debug_PathfinderVisual.prototype = {
	update: function() {
		if(this._oPathfinder == null) return;
		var material = new THREE.LineBasicMaterial({ color : 16711935});
		var geometry = new THREE.Geometry();
		var _g1 = 0;
		var _g = this._oPathfinder.worldmap_get().sizeX_get();
		while(_g1 < _g) {
			var i = _g1++;
			var _g3 = 0;
			var _g2 = this._oPathfinder.worldmap_get().sizeY_get();
			while(_g3 < _g2) {
				var j = _g3++;
				if(this._oPathfinder.refTile_getbyCoord(i,j) == null) continue;
				var v = this._oPathfinder.refMapDiff_get(i,j);
				if(v != null) {
					geometry.vertices.push(new THREE.Vector3(i - 0.2,j - 0.2,0));
					geometry.vertices.push(new THREE.Vector3(i + 0.2,j + 0.2,0));
					geometry.vertices.push(new THREE.Vector3(i + 0.2,j - 0.2,0));
					geometry.vertices.push(new THREE.Vector3(i - 0.2,j + 0.2,0));
					geometry.vertices.push(new THREE.Vector3(i,j,0));
					geometry.vertices.push(new THREE.Vector3(i + v.x * 0.5,j + v.y * 0.5,0));
				}
			}
		}
		if(this._oLine != null) {
			var scene = this._oLine.parent;
			scene.remove(this._oLine);
			this._oLine = new THREE.Line(geometry,material);
			this._oLine.position.set(5000,5000,5001);
			this._oLine.scale.set(10000,10000,10000);
			scene.add(this._oLine);
		} else {
			this._oLine = new THREE.Line(geometry,material);
			this._oLine.position.set(5000,5000,5001);
			this._oLine.scale.set(10000,10000,10000);
		}
	}
	,pathfinder_set: function(oPathfinder) {
		this._oPathfinder = oPathfinder;
		this.update();
	}
	,object3d_get: function() {
		return this._oLine;
	}
	,__class__: mygame_client_view_visual_debug_PathfinderVisual
};
var mygame_client_view_visual_gui_IUnitGauge = function() { };
$hxClasses["mygame.client.view.visual.gui.IUnitGauge"] = mygame_client_view_visual_gui_IUnitGauge;
mygame_client_view_visual_gui_IUnitGauge.__name__ = ["mygame","client","view","visual","gui","IUnitGauge"];
var mygame_client_view_visual_gui_UnitGauge = function(oUnitVisual,iIndex,sMaterialKey) {
	if(sMaterialKey == null) sMaterialKey = "hud_gauge";
	this._oUnitVisual = oUnitVisual;
	this._iIndex = iIndex;
	THREE.Mesh.call(this,this._oUnitVisual.gameView_get().geometry_get("hud_gauge"),this._oUnitVisual.gameView_get().material_get("hud_gauge_bg"));
	this.renderOrder = 10;
	this.position.setY(this._iIndex * 2);
	this._oGauge = new THREE.Mesh(this._oUnitVisual.gameView_get().geometry_get("hud_gauge"),this._oUnitVisual.gameView_get().material_get(sMaterialKey));
	this._oGauge.renderOrder = 11;
	this.add(this._oGauge);
	this._oUnitVisual.onUpdateEnd.attach(this);
};
$hxClasses["mygame.client.view.visual.gui.UnitGauge"] = mygame_client_view_visual_gui_UnitGauge;
mygame_client_view_visual_gui_UnitGauge.__name__ = ["mygame","client","view","visual","gui","UnitGauge"];
mygame_client_view_visual_gui_UnitGauge.__interfaces__ = [trigger_ITrigger,mygame_client_view_visual_gui_IUnitGauge];
mygame_client_view_visual_gui_UnitGauge.__super__ = THREE.Mesh;
mygame_client_view_visual_gui_UnitGauge.prototype = $extend(THREE.Mesh.prototype,{
	_update: function() {
		throw new js__$Boot_HaxeError("Abstract");
		this._oGauge.scale.setX(0.5);
	}
	,trigger: function(oSource) {
		this._update();
	}
	,__class__: mygame_client_view_visual_gui_UnitGauge
});
var mygame_client_view_visual_gui_HealthGauge = function(oUnitVisual,oHealth,iIndex) {
	this._oHealth = oHealth;
	mygame_client_view_visual_gui_UnitGauge.call(this,oUnitVisual,iIndex);
	this._update();
	this._oHealth.onUpdate.attach(this);
};
$hxClasses["mygame.client.view.visual.gui.HealthGauge"] = mygame_client_view_visual_gui_HealthGauge;
mygame_client_view_visual_gui_HealthGauge.__name__ = ["mygame","client","view","visual","gui","HealthGauge"];
mygame_client_view_visual_gui_HealthGauge.__super__ = mygame_client_view_visual_gui_UnitGauge;
mygame_client_view_visual_gui_HealthGauge.prototype = $extend(mygame_client_view_visual_gui_UnitGauge.prototype,{
	_update: function() {
		var x = this._oHealth.percent_get();
		if(x != 0) {
			this._oGauge.scale.setX(x);
			this._oGauge.visible = true;
		} else this._oGauge.visible = false;
	}
	,__class__: mygame_client_view_visual_gui_HealthGauge
});
var mygame_client_view_visual_gui_LoyaltyGauge = function(oUnitVisual,oLoyalty) {
	this._oLoyalty = oLoyalty;
	this._oUnitVisual = oUnitVisual;
	THREE.Mesh.call(this,this._oUnitVisual.gameView_get().geometry_get("gui_loyalty"),new THREE.MeshFaceMaterial([this.material_get_byPlayer(this._oUnitVisual.gameView_get().model_get().playerLocal_get()),this._oUnitVisual.gameView_get().material_get("player_gauge_2"),this._oUnitVisual.gameView_get().material_get("player_gauge_*")]));
	this.renderOrder = 11;
	this._oArrow = new THREE.Mesh(new THREE.PlaneGeometry(0.1,2),new THREE.MeshBasicMaterial({ color : 0, depthTest : false, depthWrite : false}));
	this._oArrow.renderOrder = 12;
	this._oArrow.scale.setY(1.2);
	this.add(this._oArrow);
	this._update();
	this._oUnitVisual.gameView_get().onFrame.attach(this);
};
$hxClasses["mygame.client.view.visual.gui.LoyaltyGauge"] = mygame_client_view_visual_gui_LoyaltyGauge;
mygame_client_view_visual_gui_LoyaltyGauge.__name__ = ["mygame","client","view","visual","gui","LoyaltyGauge"];
mygame_client_view_visual_gui_LoyaltyGauge.__interfaces__ = [trigger_ITrigger];
mygame_client_view_visual_gui_LoyaltyGauge.__super__ = THREE.Mesh;
mygame_client_view_visual_gui_LoyaltyGauge.prototype = $extend(THREE.Mesh.prototype,{
	_update: function() {
		if(this._oLoyalty.challenger_get() == this._oUnitVisual.gameView_get().model_get().playerLocal_get() || this._oLoyalty.challenger_get() == null) {
			this._oArrow.position.setX(-this._oLoyalty.loyalty_get());
			this.material.materials[1] = this.material_get(1);
		} else {
			this._oArrow.position.setX(this._oLoyalty.loyalty_get());
			this.material.materials[1] = this.material_get_byPlayer(this._oLoyalty.challenger_get());
		}
	}
	,trigger: function(oSource) {
		this._update();
	}
	,material_get_byPlayer: function(oPlayer) {
		if(oPlayer == null || oPlayer.playerId_get() > 2) return this._oUnitVisual.gameView_get().material_get("player_gauge_*");
		return this._oUnitVisual.gameView_get().material_get("player_gauge_" + (oPlayer.playerId_get() + 1));
	}
	,material_get: function(iPlayerId) {
		if(iPlayerId == null || iPlayerId < 0 || iPlayerId > 2) return this._oUnitVisual.gameView_get().material_get("player_gauge_*");
		return this._oUnitVisual.gameView_get().material_get("player_gauge_" + (iPlayerId + 1));
	}
	,__class__: mygame_client_view_visual_gui_LoyaltyGauge
});
var mygame_client_view_visual_gui_UnitSelectionPreview = function(oGameView,oModel) {
	this._oGameView = oGameView;
	this._oModel = oModel;
	this._oSelectionHint = new THREE.Mesh(new THREE.RingGeometry(1.1,1.2,32,3),new THREE.MeshBasicMaterial({ color : 13421772, wireframe : true}));
	this._oSelectionHint.scale.set(0.2,0.2,0.2);
	this._oSelectionHint.castShadow = true;
	this._oSelection = oModel.GUI_get().unitSelection_get();
	this._oSelection.onUpdate.attach(this);
	this._oModel.mouse_get().onMove.attach(this);
	this._oModel.game_get().onLoopEnd.attach(this);
	this._oGameView.onFrame.attach(this);
};
$hxClasses["mygame.client.view.visual.gui.UnitSelectionPreview"] = mygame_client_view_visual_gui_UnitSelectionPreview;
mygame_client_view_visual_gui_UnitSelectionPreview.__name__ = ["mygame","client","view","visual","gui","UnitSelectionPreview"];
mygame_client_view_visual_gui_UnitSelectionPreview.__interfaces__ = [trigger_ITrigger,mygame_client_view_visual_IVisual];
mygame_client_view_visual_gui_UnitSelectionPreview.prototype = {
	object3d_get: function() {
		return null;
	}
	,_selectionPreview_update: function(x,y) {
		var oUnitVisual = mygame_client_view_visual_unit_UnitVisual.get_byRaycasting(x,y,this._oGameView);
		var oObject = null;
		if(oUnitVisual != null) oObject = oUnitVisual.object3d_get();
		if(this._oSelectionHint.parent != oObject && this._oSelectionHint.parent != null) this._oSelectionHint.parent.remove(this._oSelectionHint);
		if(oObject != null) {
			this._oSelectionHint.scale.set(oUnitVisual.selectionScale_get(),oUnitVisual.selectionScale_get(),oUnitVisual.selectionScale_get());
			oObject.add(this._oSelectionHint);
		}
	}
	,trigger: function(oSource) {
		if(oSource == this._oModel.mouse_get().onMove) this._selectionPreview_update(this._oModel.mouse_get().x_get(),this._oModel.mouse_get().y_get());
	}
	,__class__: mygame_client_view_visual_gui_UnitSelectionPreview
};
var mygame_client_view_visual_gui_VictoryGauge = function(oGameView,oModel) {
	this._oModel = oModel;
	this._oGameView = oGameView;
	this._oScene = new THREE.Object3D();
	this._oScene.position.set(0,0.8,0);
	this._oScene.scale.set(1,0.1,1);
	this._oGameView.sceneOrtho_get().add(this._oScene);
	this._oMaterial = new THREE.MeshFaceMaterial([this.material_get_byPlayer(this._oModel.playerLocal_get()),this._oGameView.material_get("player_gauge_2"),this._oGameView.material_get("player_gauge_*")]);
	this._oGauge = new THREE.Mesh(this._oGameView.geometry_get("gui_loyalty"),new THREE.MeshBasicMaterial({ color : 65535, wireframe : true}));
	this._oGauge.renderOrder = 12;
	this._oGauge.position.setZ(-10);
	this._oGauge.scale.set(0.8,0.8,0.8);
	this._oScene.add(this._oGauge);
	this._oArrow = new THREE.Mesh(new THREE.PlaneGeometry(0.1,2),new THREE.MeshBasicMaterial({ color : 65280, depthTest : false, depthWrite : false}));
	this._oArrow.renderOrder = 10;
	this._oArrow.scale.setY(1.2);
	this._oGauge.add(this._oArrow);
	this._update();
	this._oGameView.onFrame.attach(this);
};
$hxClasses["mygame.client.view.visual.gui.VictoryGauge"] = mygame_client_view_visual_gui_VictoryGauge;
mygame_client_view_visual_gui_VictoryGauge.__name__ = ["mygame","client","view","visual","gui","VictoryGauge"];
mygame_client_view_visual_gui_VictoryGauge.__interfaces__ = [trigger_ITrigger];
mygame_client_view_visual_gui_VictoryGauge.prototype = {
	_update: function() {
		var oVictoryCondition = this._oModel.game_get().oVictoryCondition;
		if(oVictoryCondition.challenger_get() == this._oGameView.model_get().playerLocal_get() || oVictoryCondition.challenger_get() == null) this._oArrow.position.setX(-oVictoryCondition.value_get()); else this._oArrow.position.setX(oVictoryCondition.value_get());
	}
	,trigger: function(oSource) {
		if(oSource == this._oGameView.onFrame) this._update();
	}
	,material_get_byPlayer: function(oPlayer) {
		if(oPlayer == null || oPlayer.playerId_get() > 2) return this._oGameView.material_get("player_gauge_*");
		return this._oGameView.material_get("player_gauge_" + (oPlayer.playerId_get() + 1));
	}
	,material_get: function(iPlayerId) {
		if(iPlayerId == null || iPlayerId < 0 || iPlayerId > 2) return this._oGameView.material_get("player_gauge_*");
		return this._oGameView.material_get("player_gauge_" + (iPlayerId + 1));
	}
	,__class__: mygame_client_view_visual_gui_VictoryGauge
};
var mygame_client_view_visual_gui_WeaponGauge = function(oUnitVisual,oWeapon,iIndex) {
	mygame_client_view_visual_gui_UnitGauge.call(this,oUnitVisual,iIndex,"hud_gauge_red");
	this._oWeapon = oWeapon;
};
$hxClasses["mygame.client.view.visual.gui.WeaponGauge"] = mygame_client_view_visual_gui_WeaponGauge;
mygame_client_view_visual_gui_WeaponGauge.__name__ = ["mygame","client","view","visual","gui","WeaponGauge"];
mygame_client_view_visual_gui_WeaponGauge.__interfaces__ = [trigger_ITrigger];
mygame_client_view_visual_gui_WeaponGauge.__super__ = mygame_client_view_visual_gui_UnitGauge;
mygame_client_view_visual_gui_WeaponGauge.prototype = $extend(mygame_client_view_visual_gui_UnitGauge.prototype,{
	_update: function() {
		this._oGauge.scale.setX(Math.min(1,this._oWeapon.cooldown_get().expirePercent_get()));
	}
	,__class__: mygame_client_view_visual_gui_WeaponGauge
});
var mygame_client_view_visual_unit_UnitVisual = function(oGameView,oUnit,fSelectionScale) {
	if(fSelectionScale == null) fSelectionScale = 0.2;
	this._oSelectionPreview = null;
	this._oSelection = null;
	this._oGameView = oGameView;
	this._oUnit = oUnit;
	this._fSelectionScale = fSelectionScale;
	this._oClickBox = null;
	this._aGauge = [];
	this._oScene = new THREE.Group();
	this._oScene.position.setZ(0.25);
	this._oWeaponRange = null;
	mygame_client_view_visual_EntityVisual.call(this,this._oUnit);
	this._oSelection = new THREE.Mesh(this._oGameView.geometry_get("gui_selection_circle"),this._oGameView.material_get("wireframe_white"));
	this._oSelection.scale.set(this._fSelectionScale,this._fSelectionScale,this._fSelectionScale);
	this._oSelection.visible = false;
	this._oSelection.castShadow = true;
	this._oScene.add(this._oSelection);
	this._oSelectionPreview = new THREE.Mesh(this._oGameView.geometry_get("gui_selection_circle"),this._oGameView.material_get("wireframe_grey"));
	this._oSelectionPreview.scale.set(this._fSelectionScale * 1.1,this._fSelectionScale * 1.1,this._fSelectionScale * 1.1);
	this._oSelectionPreview.visible = false;
	this._oSelectionPreview.castShadow = true;
	this._oScene.add(this._oSelectionPreview);
	this._oInfoAnchor = new THREE.Object3D();
	this._oInfoAnchor.position.set(0,-this._fSelectionScale,0);
	this._oInfoAnchor.scale.set(0.25,0.05,1);
	this._oScene.add(this._oInfoAnchor);
	this._info_update();
	this._oGameView.scene_get().add(this.object3d_get());
	this._oGaugeHolder = new THREE.Object3D();
	this._oGameView.sceneOrtho_get().add(this._oGaugeHolder);
	this._oGameView.ob3UpdaterManager_get().add(new mygame_client_view_ob3updater_Follow(this._oGameView,this._oGaugeHolder,this._oInfoAnchor));
	this.onUpdateEnd = new trigger_eventdispatcher_EventDispatcher();
	var $it0 = this._oUnit.abilityMap_get().iterator();
	while( $it0.hasNext() ) {
		var oAbility = $it0.next();
		var _g;
		if(oAbility == null) _g = null; else _g = js_Boot.getClass(oAbility);
		if(_g != null) switch(_g) {
		case mygame_game_ability_Health:
			this._oGaugeHolder.add(new mygame_client_view_visual_gui_HealthGauge(this,oAbility,this._oGaugeHolder.children.length));
			break;
		case mygame_game_ability_Weapon:
			var oAbilityW;
			oAbilityW = js_Boot.__cast(oAbility , mygame_game_ability_Weapon);
			new mygame_client_view_visual_ability_WeaponVisual(this,oAbility,null);
			this._oGaugeHolder.add(new mygame_client_view_visual_gui_WeaponGauge(this,oAbility,this._oGaugeHolder.children.length));
			this._oWeaponRange = new THREE.Mesh(this._oGameView.geometry_get("gui_selection_circle"),this._oGameView.material_get("wireframe_red"));
			this._oWeaponRange.scale.set(oAbilityW.rangeMax_get(),oAbilityW.rangeMax_get(),oAbilityW.rangeMax_get());
			this._oWeaponRange.visible = false;
			this._oScene.add(this._oWeaponRange);
			break;
		case mygame_game_ability_LoyaltyShift:
			this._oGaugeHolder.add(new mygame_client_view_visual_gui_LoyaltyGauge(this,oAbility));
			break;
		}
	}
	this._oUnit.mygame_get().onLoopEnd.attach(this);
	this._oPosition = this._oUnit.ability_get(mygame_game_ability_Position);
};
$hxClasses["mygame.client.view.visual.unit.UnitVisual"] = mygame_client_view_visual_unit_UnitVisual;
mygame_client_view_visual_unit_UnitVisual.__name__ = ["mygame","client","view","visual","unit","UnitVisual"];
mygame_client_view_visual_unit_UnitVisual.get_byRaycasting = function(x,y,oGameView) {
	var oVector = utils_three_Coordonate.canva_to_eye(x,y,oGameView.renderer_get());
	var oRaycaster = new THREE.Raycaster();
	oRaycaster.setFromCamera(oVector,oGameView.camera_get());
	var _g = 0;
	var _g1 = oGameView.unitVisual_get_all();
	while(_g < _g1.length) {
		var oUnitVisual = _g1[_g];
		++_g;
		var oGeometry = oUnitVisual.clickBox_get();
		if(oGeometry == null) continue;
		var aIntersect = oRaycaster.ray.intersectBox(oGeometry);
		if(aIntersect != null) return oUnitVisual;
	}
	return null;
};
mygame_client_view_visual_unit_UnitVisual.__super__ = mygame_client_view_visual_EntityVisual;
mygame_client_view_visual_unit_UnitVisual.prototype = $extend(mygame_client_view_visual_EntityVisual.prototype,{
	selectionScale_get: function() {
		return this._fSelectionScale;
	}
	,unit_get: function() {
		return this._oUnit;
	}
	,gameView_get: function() {
		return this._oGameView;
	}
	,object3d_get: function() {
		return this._oScene;
	}
	,infoAnchor_get: function() {
		return this._oInfoAnchor;
	}
	,gaugeHolder_get: function() {
		return this._oGaugeHolder;
	}
	,clickBox_get: function() {
		if(this.unit_get() == null) return null;
		if(this._oClickBox == null && this._oScene.children.length > 1) this._clickBox_update();
		return this._oClickBox;
	}
	,update: function() {
		this._oClickBox = null;
		if(this._oPosition != null) {
			this._position_update();
			var oMapVisual = this._oGameView.entityVisual_get_byEntity(this._oPosition.map_get());
			this._oScene.position.setZ(oMapVisual.height_get(this._oPosition.x,this._oPosition.y));
			this._oScene.updateMatrix();
		}
		this.onUpdateEnd.dispatch(this);
	}
	,selection_set: function(bSelection) {
		this._oSelection.visible = bSelection;
	}
	,selectionPreview_set: function(bSelection) {
		this._oSelectionPreview.visible = bSelection;
	}
	,rangeVisualVisibility_set: function(b) {
		if(this._oWeaponRange != null) this._oWeaponRange.visible = b;
	}
	,_clickBox_update: function() {
		var oObj = this._oScene.children[this._oScene.children.length - 1];
		this._oClickBox = new THREE.Box3();
		this._oClickBox.setFromObject(oObj);
	}
	,_position_update: function() {
		this._oScene.position.setX(this._oPosition.x / 10000);
		this._oScene.position.setY(this._oPosition.y / 10000);
	}
	,_playerColoredMesh_createAdd: function(oParent,bFlat) {
		if(bFlat == null) bFlat = false;
		var oMesh;
		var oMaterial = null;
		if(bFlat) oMaterial = this._oGameView.material_get_byPlayer("player_flat",this.unit_get().owner_get()); else oMaterial = this._oGameView.material_get_byPlayer("player",this.unit_get().owner_get());
		oMesh = new THREE.Mesh(oParent.geometry.clone(),oMaterial);
		oParent.add(oMesh);
		return oMesh;
	}
	,_info_update: function() {
		this._oInfoAnchor.updateMatrix();
	}
	,trigger: function(oSource) {
		if(oSource == this._oUnit.mygame_get().onLoopEnd) {
			this.update();
			this._info_update();
		}
		if(oSource == this._oEntity.onDispose) this._decay_start();
	}
	,_decay_start: function() {
		this.dispose();
	}
	,dispose: function() {
		this._oUnit.mygame_get().onLoopEnd.remove(this);
		this._oSelection.parent.remove(this._oSelection);
		this._oSelection = null;
		this._oInfoAnchor.parent.remove(this._oInfoAnchor);
		this._oInfoAnchor = null;
		this._oGaugeHolder.parent.remove(this._oGaugeHolder);
		this._oGaugeHolder = null;
		mygame_client_view_visual_EntityVisual.prototype.dispose.call(this);
	}
	,__class__: mygame_client_view_visual_unit_UnitVisual
});
var mygame_client_view_visual_unit_BazooVisual = function(oDisplayer,oUnit) {
	mygame_client_view_visual_unit_UnitVisual.call(this,oDisplayer,oUnit);
	this._oBody = new THREE.Mesh(oDisplayer.geometry_get("bazoo"),new THREE.MeshFaceMaterial([oDisplayer.material_get("soldier"),this._oGameView.material_get_byPlayer("player",this.unit_get().owner_get())]));
	var oVolume = oUnit.ability_get(mygame_game_ability_Volume);
	if(oVolume != null) this._oBody.scale.set(oVolume.size_get(),oVolume.size_get(),oVolume.size_get()); else this._oBody.scale.set(0.2,0.2,0.2);
	this._oBody.rotation.set(0,0,-0.8);
	this._oBody.castShadow = true;
	this._oBody.updateMatrix();
	this._oScene.add(this._oBody);
	this.update();
};
$hxClasses["mygame.client.view.visual.unit.BazooVisual"] = mygame_client_view_visual_unit_BazooVisual;
mygame_client_view_visual_unit_BazooVisual.__name__ = ["mygame","client","view","visual","unit","BazooVisual"];
mygame_client_view_visual_unit_BazooVisual.__super__ = mygame_client_view_visual_unit_UnitVisual;
mygame_client_view_visual_unit_BazooVisual.prototype = $extend(mygame_client_view_visual_unit_UnitVisual.prototype,{
	entity_get: function() {
		return this._oUnit;
	}
	,update: function() {
		mygame_client_view_visual_unit_UnitVisual.prototype.update.call(this);
		var oMobility = this._oUnit.ability_get(mygame_game_ability_Mobility);
		if(oMobility != null) this._oBody.rotation.set(0,0,oMobility.orientation_get());
	}
	,__class__: mygame_client_view_visual_unit_BazooVisual
});
var mygame_client_view_visual_unit_CityVisual = function(oDisplayer,oUnit) {
	mygame_client_view_visual_unit_UnitVisual.call(this,oDisplayer,oUnit,0.5);
	var oMaterial = new THREE.MeshFaceMaterial([oDisplayer.material_get("city"),this._oGameView.material_get_byPlayer("player_flat",this.unit_get().owner_get())]);
	this._oMesh = new THREE.Mesh(oDisplayer.geometry_get("city"),oMaterial);
	this._oMesh.scale.set(0.5,0.5,0.5);
	this._oMesh.castShadow = true;
	this._oScene.add(this._oMesh);
	this.update();
	this._position_update();
	this.unit_get().onUpdate.attach(this);
};
$hxClasses["mygame.client.view.visual.unit.CityVisual"] = mygame_client_view_visual_unit_CityVisual;
mygame_client_view_visual_unit_CityVisual.__name__ = ["mygame","client","view","visual","unit","CityVisual"];
mygame_client_view_visual_unit_CityVisual.__interfaces__ = [trigger_ITrigger];
mygame_client_view_visual_unit_CityVisual.__super__ = mygame_client_view_visual_unit_UnitVisual;
mygame_client_view_visual_unit_CityVisual.prototype = $extend(mygame_client_view_visual_unit_UnitVisual.prototype,{
	entity_get: function() {
		return this._oUnit;
	}
	,banner_update: function() {
		(js_Boot.__cast(this._oMesh.material , THREE.MeshFaceMaterial)).materials[1] = this._oGameView.material_get_byPlayer("player_flat",this.unit_get().owner_get());
	}
	,update: function() {
		return;
	}
	,trigger: function(oSource) {
		mygame_client_view_visual_unit_UnitVisual.prototype.trigger.call(this,oSource);
		if(oSource == this.unit_get().onUpdate) this.banner_update();
	}
	,__class__: mygame_client_view_visual_unit_CityVisual
});
var mygame_client_view_visual_unit_CopterVisual = function(oDisplayer,oUnit) {
	mygame_client_view_visual_unit_UnitVisual.call(this,oDisplayer,oUnit);
	var oMaterial = new THREE.MeshFaceMaterial([this._oGameView.material_get_byPlayer("player_flat",this.unit_get().owner_get()),oDisplayer.material_get("copter")]);
	this._oBody = new THREE.Mesh(oDisplayer.geometry_get("copter"),oMaterial);
	this._oBody.scale.set(0.166,0.166,0.166);
	this._oBody.rotation.set(0,0,-0.8);
	this._oBody.castShadow = true;
	this._oBody.updateMatrix();
	this._oBody.position.setZ(2);
	this._oScene.add(this._oBody);
	var geometry = new THREE.Geometry();
	geometry.vertices.push(new THREE.Vector3(0,0,0));
	geometry.vertices.push(new THREE.Vector3(0,0,2));
	this._oHeightLine = new THREE.Line(geometry,mygame_client_view_visual_unit_CopterVisual._oMaterial);
	this._oScene.add(this._oHeightLine);
	this.update();
};
$hxClasses["mygame.client.view.visual.unit.CopterVisual"] = mygame_client_view_visual_unit_CopterVisual;
mygame_client_view_visual_unit_CopterVisual.__name__ = ["mygame","client","view","visual","unit","CopterVisual"];
mygame_client_view_visual_unit_CopterVisual.__super__ = mygame_client_view_visual_unit_UnitVisual;
mygame_client_view_visual_unit_CopterVisual.prototype = $extend(mygame_client_view_visual_unit_UnitVisual.prototype,{
	entity_get: function() {
		return this._oUnit;
	}
	,update: function() {
		mygame_client_view_visual_unit_UnitVisual.prototype.update.call(this);
		var oMobility = this._oUnit.ability_get(mygame_game_ability_Mobility);
		if(oMobility != null) this._oBody.rotation.set(0,0,oMobility.orientation_get());
	}
	,__class__: mygame_client_view_visual_unit_CopterVisual
});
var mygame_client_view_visual_unit_FactoryVisual = function(oDisplayer,oUnit) {
	mygame_client_view_visual_unit_UnitVisual.call(this,oDisplayer,oUnit,0.5);
	this._oMesh = new THREE.Mesh(oDisplayer.geometry_get("factory"),oDisplayer.material_get("factory"));
	this._oMesh.scale.set(0.5,0.5,0.5);
	this._oMesh.castShadow = true;
	this._oScene.add(this._oMesh);
	this._oBanner = this._playerColoredMesh_createAdd(this._oMesh,true);
	this.update();
	this.unit_get().onUpdate.attach(this);
};
$hxClasses["mygame.client.view.visual.unit.FactoryVisual"] = mygame_client_view_visual_unit_FactoryVisual;
mygame_client_view_visual_unit_FactoryVisual.__name__ = ["mygame","client","view","visual","unit","FactoryVisual"];
mygame_client_view_visual_unit_FactoryVisual.__interfaces__ = [trigger_ITrigger];
mygame_client_view_visual_unit_FactoryVisual.__super__ = mygame_client_view_visual_unit_UnitVisual;
mygame_client_view_visual_unit_FactoryVisual.prototype = $extend(mygame_client_view_visual_unit_UnitVisual.prototype,{
	entity_get: function() {
		return this._oUnit;
	}
	,banner_update: function() {
		this._oBanner.material = this._oGameView.material_get_byPlayer("player_flat",this.unit_get().owner_get());
	}
	,_clickBox_update: function() {
		mygame_client_view_visual_unit_UnitVisual.prototype._clickBox_update.call(this);
		this._oClickBox.max.z /= 2;
	}
	,trigger: function(oSource) {
		mygame_client_view_visual_unit_UnitVisual.prototype.trigger.call(this,oSource);
		if(oSource == this.unit_get().onUpdate) this.banner_update();
	}
	,__class__: mygame_client_view_visual_unit_FactoryVisual
});
var mygame_client_view_visual_unit_PlatoonVisual = function(oDisplayer,oUnit) {
	mygame_client_view_visual_unit_UnitVisual.call(this,oDisplayer,oUnit);
	this._oBody = new THREE.Mesh(oDisplayer.geometry_get("city"),this._oGameView.material_get_byPlayer("player",this.unit_get().owner_get()));
	this._oBody.scale.set(0.3,0.3,0.3);
	this._oBody.rotation.set(0,0,-0.8);
	this._oBody.castShadow = true;
	this._oBody.updateMatrix();
	this.update();
};
$hxClasses["mygame.client.view.visual.unit.PlatoonVisual"] = mygame_client_view_visual_unit_PlatoonVisual;
mygame_client_view_visual_unit_PlatoonVisual.__name__ = ["mygame","client","view","visual","unit","PlatoonVisual"];
mygame_client_view_visual_unit_PlatoonVisual.__super__ = mygame_client_view_visual_unit_UnitVisual;
mygame_client_view_visual_unit_PlatoonVisual.prototype = $extend(mygame_client_view_visual_unit_UnitVisual.prototype,{
	entity_get: function() {
		return this._oUnit;
	}
	,update: function() {
		var v = this._subUnitPositionAvr_get();
		this._oScene.position.setX(v.x);
		this._oScene.position.setY(v.y);
		this.onUpdateEnd.dispatch(this);
	}
	,_subUnitPositionAvr_get: function() {
		var oPos = new THREE.Vector2();
		var aUnit = this._oUnit.ability_get(mygame_game_ability_Platoon).subUnit_get();
		var _g = 0;
		while(_g < aUnit.length) {
			var oUnit = aUnit[_g];
			++_g;
			oPos.x += oUnit.ability_get(mygame_game_ability_Position).x;
			oPos.y += oUnit.ability_get(mygame_game_ability_Position).y;
		}
		oPos.divideScalar(aUnit.length);
		return oPos;
	}
	,__class__: mygame_client_view_visual_unit_PlatoonVisual
});
var mygame_client_view_visual_unit_SoldierVisual = function(oDisplayer,oUnit) {
	mygame_client_view_visual_unit_UnitVisual.call(this,oDisplayer,oUnit);
	var oMaterial = new THREE.MeshFaceMaterial([oDisplayer.material_get("soldier"),this._oGameView.material_get_byPlayer("player",this.unit_get().owner_get())]);
	this._oBody = new THREE.Mesh(oDisplayer.geometry_get("soldier"),oMaterial);
	this._oBody.scale.set(0.1,0.1,0.1);
	this._oBody.rotation.set(0,0,-0.8);
	this._oBody.castShadow = true;
	this._oBody.updateMatrix();
	this._oScene.add(this._oBody);
	this.update();
};
$hxClasses["mygame.client.view.visual.unit.SoldierVisual"] = mygame_client_view_visual_unit_SoldierVisual;
mygame_client_view_visual_unit_SoldierVisual.__name__ = ["mygame","client","view","visual","unit","SoldierVisual"];
mygame_client_view_visual_unit_SoldierVisual.__super__ = mygame_client_view_visual_unit_UnitVisual;
mygame_client_view_visual_unit_SoldierVisual.prototype = $extend(mygame_client_view_visual_unit_UnitVisual.prototype,{
	entity_get: function() {
		return this._oUnit;
	}
	,update: function() {
		mygame_client_view_visual_unit_UnitVisual.prototype.update.call(this);
		var oMobility = this._oUnit.ability_get(mygame_game_ability_Mobility);
		if(oMobility != null) this._oBody.rotation.set(0,0,oMobility.orientation_get());
	}
	,__class__: mygame_client_view_visual_unit_SoldierVisual
});
var mygame_client_view_visual_unit_TankVisual = function(oDisplayer,oUnit) {
	var i = oUnit.ability_get(mygame_game_ability_Volume).size_get() / 10000;
	mygame_client_view_visual_unit_UnitVisual.call(this,oDisplayer,oUnit,i);
	var oMesh = new THREE.Object3D();
	oMesh.scale.set(i,i,i);
	this._oScene.add(oMesh);
	this._oBody = new THREE.Mesh(oDisplayer.geometry_get("tank_body"),new THREE.MeshFaceMaterial([oDisplayer.material_get("tank"),this._oGameView.material_get_byPlayer("player_flat",this.unit_get().owner_get())]));
	this._oBody.castShadow = true;
	this._oBody.renderOrder = 1;
	oMesh.add(this._oBody);
	this._oTurret = new THREE.Mesh(oDisplayer.geometry_get("tank_turret"),new THREE.MeshFaceMaterial([oDisplayer.material_get("tank"),this._oGameView.material_get_byPlayer("player_flat",this.unit_get().owner_get())]));
	this._oTurret.position.set(0,0,0.5);
	oMesh.add(this._oTurret);
	this.update();
};
$hxClasses["mygame.client.view.visual.unit.TankVisual"] = mygame_client_view_visual_unit_TankVisual;
mygame_client_view_visual_unit_TankVisual.__name__ = ["mygame","client","view","visual","unit","TankVisual"];
mygame_client_view_visual_unit_TankVisual.__super__ = mygame_client_view_visual_unit_UnitVisual;
mygame_client_view_visual_unit_TankVisual.prototype = $extend(mygame_client_view_visual_unit_UnitVisual.prototype,{
	entity_get: function() {
		return this._oUnit;
	}
	,update: function() {
		mygame_client_view_visual_unit_UnitVisual.prototype.update.call(this);
		var oMobility = this._oUnit.ability_get(mygame_game_ability_Mobility);
		if(oMobility != null) this._oBody.rotation.z = oMobility.orientation_get();
		var oWeapon = this._oUnit.ability_get(mygame_game_ability_Weapon);
		if(oWeapon.target_get() != null) {
			var oVisual = mygame_client_view_visual_EntityVisual.get_byEntity(oWeapon.target_get());
			if(oVisual != null) {
				var targetPos = oVisual.object3d_get().localToWorld(new THREE.Vector3(0,0,0));
				var myPos = this.object3d_get().localToWorld(new THREE.Vector3(0,0,0));
				var v = new THREE.Vector3();
				v.subVectors(targetPos,myPos);
				var a = Math.atan2(v.y,v.x);
				this._oTurret.rotation.z = a;
			}
		} else this._oTurret.rotation.z = this._oBody.rotation.z;
	}
	,__class__: mygame_client_view_visual_unit_TankVisual
});
var mygame_connection_MySerializer = function() {
	haxe_Serializer.call(this);
	this.useRelative_set(mygame_connection_MySerializer._bUSE_RELATIVE);
};
$hxClasses["mygame.connection.MySerializer"] = mygame_connection_MySerializer;
mygame_connection_MySerializer.__name__ = ["mygame","connection","MySerializer"];
mygame_connection_MySerializer.run = function(v) {
	var s = new mygame_connection_MySerializer();
	s.serialize(v);
	return s.toString();
};
mygame_connection_MySerializer.__super__ = haxe_Serializer;
mygame_connection_MySerializer.prototype = $extend(haxe_Serializer.prototype,{
	useRelative_set: function(bUseRelative) {
		this._bUseRelative = bUseRelative;
	}
	,serialize: function(v) {
		if(this._bUseRelative && js_Boot.__instanceof(v,legion_entity_Entity)) {
			this.buf.b += "U";
			this.serialize(v.identity_get());
		} else haxe_Serializer.prototype.serialize.call(this,v);
	}
	,__class__: mygame_connection_MySerializer
});
var mygame_connection_MyUnserializer = function(s,oGame) {
	haxe_Unserializer.call(this,s);
	this.game_set(oGame);
};
$hxClasses["mygame.connection.MyUnserializer"] = mygame_connection_MyUnserializer;
mygame_connection_MyUnserializer.__name__ = ["mygame","connection","MyUnserializer"];
mygame_connection_MyUnserializer.run = function(s,oGame) {
	return new mygame_connection_MyUnserializer(s,oGame).unserialize();
};
mygame_connection_MyUnserializer.__super__ = haxe_Unserializer;
mygame_connection_MyUnserializer.prototype = $extend(haxe_Unserializer.prototype,{
	game_set: function(oGame) {
		this._oGame = oGame;
	}
	,unserialize: function() {
		var _g = this.get(this.pos++);
		switch(_g) {
		case 85:
			var id = this.unserialize();
			var v = this._oGame.entity_get(id);
			if(v == null) throw new js__$Boot_HaxeError("No reference for Entity #" + id + " for given game");
			return v;
		default:
			this.pos--;
			return haxe_Unserializer.prototype.unserialize.call(this);
		}
	}
	,__class__: mygame_connection_MyUnserializer
});
var websocket_IMessage = function() { };
$hxClasses["websocket.IMessage"] = websocket_IMessage;
websocket_IMessage.__name__ = ["websocket","IMessage"];
var mygame_connection_message_IGameMessage = function() { };
$hxClasses["mygame.connection.message.IGameMessage"] = mygame_connection_message_IGameMessage;
mygame_connection_message_IGameMessage.__name__ = ["mygame","connection","message","IGameMessage"];
mygame_connection_message_IGameMessage.__interfaces__ = [websocket_IMessage];
var mygame_connection_message_ILobbyMessage = function() { };
$hxClasses["mygame.connection.message.ILobbyMessage"] = mygame_connection_message_ILobbyMessage;
mygame_connection_message_ILobbyMessage.__name__ = ["mygame","connection","message","ILobbyMessage"];
mygame_connection_message_ILobbyMessage.__interfaces__ = [websocket_IMessage];
var mygame_connection_message_ReqGameJoin = function(iGameId,iSlotId) {
	if(iSlotId == null) iSlotId = -1;
	this._iGameId = iGameId;
	this._iSlotId = iSlotId;
};
$hxClasses["mygame.connection.message.ReqGameJoin"] = mygame_connection_message_ReqGameJoin;
mygame_connection_message_ReqGameJoin.__name__ = ["mygame","connection","message","ReqGameJoin"];
mygame_connection_message_ReqGameJoin.__interfaces__ = [mygame_connection_message_ILobbyMessage];
mygame_connection_message_ReqGameJoin.prototype = {
	gameId_get: function() {
		return this._iGameId;
	}
	,slotId_get: function() {
		return this._iSlotId;
	}
	,__class__: mygame_connection_message_ReqGameJoin
};
var mygame_connection_message_ReqPlayerInput = function(oAction) {
	this._oAction = oAction;
};
$hxClasses["mygame.connection.message.ReqPlayerInput"] = mygame_connection_message_ReqPlayerInput;
mygame_connection_message_ReqPlayerInput.__name__ = ["mygame","connection","message","ReqPlayerInput"];
mygame_connection_message_ReqPlayerInput.__interfaces__ = [mygame_connection_message_IGameMessage];
mygame_connection_message_ReqPlayerInput.prototype = {
	action_get: function(oPlayer) {
		return this._oAction;
	}
	,__class__: mygame_connection_message_ReqPlayerInput
};
var mygame_connection_message_ReqShutDown = function() {
};
$hxClasses["mygame.connection.message.ReqShutDown"] = mygame_connection_message_ReqShutDown;
mygame_connection_message_ReqShutDown.__name__ = ["mygame","connection","message","ReqShutDown"];
mygame_connection_message_ReqShutDown.__interfaces__ = [mygame_connection_message_ILobbyMessage];
mygame_connection_message_ReqShutDown.prototype = {
	__class__: mygame_connection_message_ReqShutDown
};
var mygame_connection_message_ReqSlotList = function() {
};
$hxClasses["mygame.connection.message.ReqSlotList"] = mygame_connection_message_ReqSlotList;
mygame_connection_message_ReqSlotList.__name__ = ["mygame","connection","message","ReqSlotList"];
mygame_connection_message_ReqSlotList.__interfaces__ = [mygame_connection_message_ILobbyMessage];
mygame_connection_message_ReqSlotList.prototype = {
	__class__: mygame_connection_message_ReqSlotList
};
var mygame_connection_message_ResGameJoin = function(fSpeed) {
	this._fSpeed = fSpeed;
};
$hxClasses["mygame.connection.message.ResGameJoin"] = mygame_connection_message_ResGameJoin;
mygame_connection_message_ResGameJoin.__name__ = ["mygame","connection","message","ResGameJoin"];
mygame_connection_message_ResGameJoin.__interfaces__ = [mygame_connection_message_ILobbyMessage];
mygame_connection_message_ResGameJoin.prototype = {
	__class__: mygame_connection_message_ResGameJoin
};
var mygame_connection_message_ResGameStepInput = function(iLoopId,loInput) {
	this._iLoopId = iLoopId;
	this._loInput = loInput;
};
$hxClasses["mygame.connection.message.ResGameStepInput"] = mygame_connection_message_ResGameStepInput;
mygame_connection_message_ResGameStepInput.__name__ = ["mygame","connection","message","ResGameStepInput"];
mygame_connection_message_ResGameStepInput.__interfaces__ = [mygame_connection_message_IGameMessage];
mygame_connection_message_ResGameStepInput.prototype = {
	loopId_get: function() {
		return this._iLoopId;
	}
	,inputList_get: function() {
		return this._loInput;
	}
	,__class__: mygame_connection_message_ResGameStepInput
};
var mygame_connection_message_ResSlotList = function() {
	this.liGameId = new List();
};
$hxClasses["mygame.connection.message.ResSlotList"] = mygame_connection_message_ResSlotList;
mygame_connection_message_ResSlotList.__name__ = ["mygame","connection","message","ResSlotList"];
mygame_connection_message_ResSlotList.__interfaces__ = [mygame_connection_message_ILobbyMessage];
mygame_connection_message_ResSlotList.prototype = {
	__class__: mygame_connection_message_ResSlotList
};
var mygame_connection_message_clientsent_ReqReadyUpdate = function(bReady) {
	this._bReady = bReady;
};
$hxClasses["mygame.connection.message.clientsent.ReqReadyUpdate"] = mygame_connection_message_clientsent_ReqReadyUpdate;
mygame_connection_message_clientsent_ReqReadyUpdate.__name__ = ["mygame","connection","message","clientsent","ReqReadyUpdate"];
mygame_connection_message_clientsent_ReqReadyUpdate.__interfaces__ = [mygame_connection_message_ILobbyMessage];
mygame_connection_message_clientsent_ReqReadyUpdate.prototype = {
	ready_get: function() {
		return this._bReady;
	}
	,__class__: mygame_connection_message_clientsent_ReqReadyUpdate
};
var mygame_connection_message_serversent_RoomStatus = function(oRoom) {
	this.aUser = [];
	this.iGameSpeed = Std["int"](oRoom.gameSpeed_get());
	var aPause = oRoom.pauseList_get();
	var _g1 = 0;
	var _g = aPause.length;
	while(_g1 < _g) {
		var i = _g1++;
		this.aUser[i] = new haxe_ds_StringMap();
		this.aUser[i].set("name","player" + i);
		this.aUser[i].set("ready",aPause[i]);
		this.aUser[i].set("playerindex",i);
	}
};
$hxClasses["mygame.connection.message.serversent.RoomStatus"] = mygame_connection_message_serversent_RoomStatus;
mygame_connection_message_serversent_RoomStatus.__name__ = ["mygame","connection","message","serversent","RoomStatus"];
mygame_connection_message_serversent_RoomStatus.__interfaces__ = [mygame_connection_message_ILobbyMessage];
mygame_connection_message_serversent_RoomStatus.prototype = {
	__class__: mygame_connection_message_serversent_RoomStatus
};
var mygame_game_MyGame = function() {
	this._oMap = null;
	this._iLoop = 0;
	legion_Game.call(this);
	this.onLoop = new trigger_eventdispatcher_EventDispatcher();
	this.onLoopEnd = new trigger_eventdispatcher_EventDispatcher();
	this.onHealthAnyUpdate = new trigger_EventDispatcher2();
	this._aoHero = [];
	this._loUnit = new List();
	this._aoPlayer = [];
	this._oPositionDistance = new mygame_game_misc_PositionDistance();
	this._oWinner = null;
	this._aAction = new haxe_ds_IntMap();
	this._singleton_add(new mygame_game_misc_weapon_WeaponTypeBazoo());
	this._singleton_add(new mygame_game_misc_weapon_WeaponTypeSoldier());
	this._singleton_add(new mygame_game_query_CityTile(this));
	this._singleton_add(new mygame_game_query_UnitDist(this));
	this._singleton_add(new mygame_game_query_UnitQuery(this));
	new mygame_game_process_VolumeEjection(this);
	new mygame_game_process_MobilityProcess(this);
	this.oWeaponProcess = new mygame_game_process_WeaponProcess(this);
	new mygame_game_process_LoyaltyShiftProcess(this);
	new mygame_game_process_Death(this);
	this.oVictoryCondition = new mygame_game_process_VictoryCondition(this);
	this._oMap = mygame_game_entity_WorldMap.load({ iSizeX : 15, iSizeY : 10, aoTile : [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,1,2,4,4,4,4,4,1,2,1,1,1,0],[0,1,1,2,4,2,0,1,4,1,1,1,1,1,0],[0,1,1,4,4,0,0,0,4,1,3,1,4,1,0],[0,1,1,4,1,0,0,0,4,1,3,1,4,1,0],[0,1,4,4,1,0,0,2,4,4,4,4,4,1,0],[0,1,1,1,1,1,1,2,2,1,0,0,4,0,0],[0,0,1,1,1,1,1,1,1,1,0,0,1,1,0],[0,0,0,1,3,1,3,2,1,1,4,1,1,1,0],[0,0,0,1,1,1,1,0,0,0,0,0,0,4,0]]},this);
	this.player_add(new mygame_game_entity_Player(this,"Blue"));
	this.player_add(new mygame_game_entity_Player(this,"Yellow"));
	this.entity_add(this._oMap);
	this.entity_add(new mygame_game_entity_City(this,null,this._oMap.tile_get(2,6)));
	this.entity_add(new mygame_game_entity_City(this,null,this._oMap.tile_get(2,13)));
	this.entity_add(new mygame_game_entity_City(this,null,this._oMap.tile_get(9,1)));
	this.entity_add(new mygame_game_entity_City(this,null,this._oMap.tile_get(9,18)));
	this.entity_add(new mygame_game_entity_City(this,null,this._oMap.tile_get(13,7)));
	this.entity_add(new mygame_game_entity_City(this,null,this._oMap.tile_get(13,12)));
	this.entity_add(new mygame_game_entity_Factory(this,this.player_get(0),this._oMap.tile_get(3,2)));
	this.entity_add(new mygame_game_entity_Factory(this,this.player_get(1),this._oMap.tile_get(3,17)));
	this.entity_add(new mygame_game_entity_Tank(this,this.player_get(1),new space_Vector2i(35000,35000)));
	this._aoHero[0] = this._aoEntity[this._aoEntity.length - 1];
	this._aoHero[1] = this._aoEntity[this._aoEntity.length - 1];
};
$hxClasses["mygame.game.MyGame"] = mygame_game_MyGame;
mygame_game_MyGame.__name__ = ["mygame","game","MyGame"];
mygame_game_MyGame.load = function(oGameState) {
	if(typeof(oGameState) == "string") return haxe_Unserializer.run(oGameState);
	throw new js__$Boot_HaxeError("[ERROR] MyGame : load : can not resolve.");
	return null;
};
mygame_game_MyGame.__super__ = legion_Game;
mygame_game_MyGame.prototype = $extend(legion_Game.prototype,{
	loop: function() {
		this._iLoop++;
		this.onLoop.dispatch(this);
		this.onLoopEnd.dispatch(this);
	}
	,log_get: function() {
		return this._aAction;
	}
	,winner_get: function() {
		return this._oWinner;
	}
	,map_get: function() {
		return this._oMap;
	}
	,loopId_get: function() {
		return this._iLoop;
	}
	,hero_get: function(oPlayer) {
		return this._aoHero[oPlayer.playerId_get()];
	}
	,action_run: function(oAction) {
		if(!oAction.check(this)) return false;
		if(this._aAction.h[this._iLoop] == null) this._aAction.set(this._iLoop,new List());
		this._aAction.h[this._iLoop].add(oAction);
		oAction.exec(this);
		return true;
	}
	,entity_add: function(oEntity) {
		legion_Game.prototype.entity_add.call(this,oEntity);
		if(js_Boot.__instanceof(oEntity,mygame_game_entity_Unit)) {
			var oUnit = oEntity;
			this._loUnit.push(oUnit);
			var oPlatoon = oUnit.ability_get(mygame_game_ability_Platoon);
			if(oPlatoon != null) {
				var aUnit = oPlatoon.subUnit_get();
				var _g = 0;
				while(_g < aUnit.length) {
					var oSubUnit = aUnit[_g];
					++_g;
					this.entity_add(oSubUnit);
				}
			}
		}
	}
	,entity_remove: function(oEntity) {
		legion_Game.prototype.entity_remove.call(this,oEntity);
		if(js_Boot.__instanceof(oEntity,mygame_game_entity_Unit)) this._loUnit.remove(oEntity);
	}
	,unitList_get: function() {
		return this._loUnit;
	}
	,player_get: function(iKey) {
		return this._aoPlayer[iKey];
	}
	,positionDistance_get: function() {
		return this._oPositionDistance;
	}
	,end: function(oWinner) {
		this._oWinner = oWinner;
	}
	,player_add: function(oPlayer) {
		var i = this._aoPlayer.length;
		this._aoPlayer[i] = oPlayer;
		oPlayer.playerId_set(i);
		this.entity_add(oPlayer);
		return i;
	}
	,save: function() {
		haxe_Serializer.USE_CACHE = true;
		return haxe_Serializer.run(this);
	}
	,__class__: mygame_game_MyGame
});
var mygame_game_ability_UnitAbility = function(oUnit) {
	this._oUnit = oUnit;
	this.onDispose = new trigger_eventdispatcher_EventDispatcher();
};
$hxClasses["mygame.game.ability.UnitAbility"] = mygame_game_ability_UnitAbility;
mygame_game_ability_UnitAbility.__name__ = ["mygame","game","ability","UnitAbility"];
mygame_game_ability_UnitAbility.__interfaces__ = [legion_ability_IAbility];
mygame_game_ability_UnitAbility.prototype = {
	unit_get: function() {
		return this._oUnit;
	}
	,mainClassName_get: function() {
		return Type.getClassName(js_Boot.getClass(this));
	}
	,dispose: function() {
		this.onDispose.dispatch(this);
		this._oUnit.game_get().onAbilityDispose.dispatch(this);
		utils_Disposer.dispose(this);
	}
	,__class__: mygame_game_ability_UnitAbility
};
var mygame_game_ability_Builder = function(oUnit) {
	mygame_game_ability_UnitAbility.call(this,oUnit);
	this._oProduct = [];
};
$hxClasses["mygame.game.ability.Builder"] = mygame_game_ability_Builder;
mygame_game_ability_Builder.__name__ = ["mygame","game","ability","Builder"];
mygame_game_ability_Builder.__super__ = mygame_game_ability_UnitAbility;
mygame_game_ability_Builder.prototype = $extend(mygame_game_ability_UnitAbility.prototype,{
	product_add: function(oOffer) {
	}
	,productArray_get: function() {
		return this._oProduct;
	}
	,__class__: mygame_game_ability_Builder
});
var mygame_game_misc_offer_Offer = function(iCost,sName) {
	this._sName = sName;
	this._iCost = 10;
};
$hxClasses["mygame.game.misc.offer.Offer"] = mygame_game_misc_offer_Offer;
mygame_game_misc_offer_Offer.__name__ = ["mygame","game","misc","offer","Offer"];
mygame_game_misc_offer_Offer.prototype = {
	cost_get: function() {
		return this._iCost;
	}
	,name_get: function() {
		return this._sName;
	}
	,accept: function(oBuyer,oSeller) {
		oBuyer.credit_add(-this._iCost);
	}
	,__class__: mygame_game_misc_offer_Offer
};
var mygame_game_ability_BuilderFactory = function(oUnit) {
	mygame_game_ability_Builder.call(this,oUnit);
	var oPosition = this._oUnit.ability_get(mygame_game_ability_Position);
	if(oPosition == null) throw new js__$Boot_HaxeError("[ERROR]:buy:seller must have Position ability.");
	this._oPosition = oPosition.clone();
	this._oRallyPoint = this._oPosition.clone();
	this._oRallyPoint.y -= 4999;
};
$hxClasses["mygame.game.ability.BuilderFactory"] = mygame_game_ability_BuilderFactory;
mygame_game_ability_BuilderFactory.__name__ = ["mygame","game","ability","BuilderFactory"];
mygame_game_ability_BuilderFactory.__super__ = mygame_game_ability_Builder;
mygame_game_ability_BuilderFactory.prototype = $extend(mygame_game_ability_Builder.prototype,{
	offerArray_get: function() {
		return mygame_game_ability_BuilderFactory._aOffer;
	}
	,buy: function(iOfferIndex) {
		if(iOfferIndex < 0 || iOfferIndex >= mygame_game_ability_BuilderFactory._aOffer.length) throw new js__$Boot_HaxeError("[ERROR]:" + iOfferIndex + " is an invalide offer index.");
		if(this._oUnit.owner_get() == null) throw new js__$Boot_HaxeError("[ERROR]:neutral unit can not sell.");
		this._oUnit.owner_get().credit_add(-mygame_game_ability_BuilderFactory._aOffer[iOfferIndex].cost_get());
		var oProduct = this.unit_create(iOfferIndex);
		var oGuidance = oProduct.ability_get(mygame_game_ability_Guidance);
		if(oGuidance == null) throw new js__$Boot_HaxeError("[ERROR]:buy:product must have Guidance ability.");
		oGuidance.goal_set(this._oRallyPoint);
	}
	,unit_create: function(i) {
		switch(i) {
		case 99:
			var u = new mygame_game_entity_Soldier(this._oUnit.game_get(),this._oUnit.owner_get(),this._oPosition);
			this._oUnit.game_get().entity_add(u);
			return u;
		case 98:
			var u1 = new mygame_game_entity_Bazoo(this._oUnit.game_get(),this._oUnit.owner_get(),this._oPosition);
			this._oUnit.game_get().entity_add(u1);
			return u1;
		case 1:
			var u2 = new mygame_game_entity_Tank(this._oUnit.game_get(),this._oUnit.owner_get(),this._oPosition);
			this._oUnit.game_get().entity_add(u2);
			return u2;
		case 0:
			var u3 = new mygame_game_entity_PlatoonUnit(this._oUnit.game_get(),this._oUnit.owner_get(),this._oPosition);
			this._oUnit.game_get().entity_add(u3);
			return u3;
		default:
			throw new js__$Boot_HaxeError("wooops");
		}
		return null;
	}
	,__class__: mygame_game_ability_BuilderFactory
});
var mygame_game_ability_Guidance = function(oUnit) {
	mygame_game_ability_UnitAbility.call(this,oUnit);
	this._oMobility = oUnit.ability_get(mygame_game_ability_Mobility);
	if(this._oMobility == null) throw new js__$Boot_HaxeError("Guidance require mobility");
	this._oVolume = oUnit.ability_get(mygame_game_ability_Volume);
	this._oPlan = oUnit.ability_get(mygame_game_ability_PositionPlan);
	this._oPathfinder = null;
	this.goal_set(null);
};
$hxClasses["mygame.game.ability.Guidance"] = mygame_game_ability_Guidance;
mygame_game_ability_Guidance.__name__ = ["mygame","game","ability","Guidance"];
mygame_game_ability_Guidance.__super__ = mygame_game_ability_UnitAbility;
mygame_game_ability_Guidance.prototype = $extend(mygame_game_ability_UnitAbility.prototype,{
	goal_get: function() {
		return this._oGoal;
	}
	,mobility_get: function() {
		return this._oMobility;
	}
	,pathfinder_get: function() {
		return this._oPathfinder;
	}
	,goal_set: function(oDestination) {
		if(oDestination == null) {
			this._oGoal = null;
			this._oGoalTile = null;
			return;
		}
		var oTileDestination = this._oMobility.position_get().map_get().tile_get_byUnitMetric(oDestination.x,oDestination.y);
		if(!this._oPlan.tile_check(oTileDestination)) {
			this._oGoal = null;
			this._oGoalTile = null;
			return;
		}
		var lDestination = new List();
		lDestination.add(oTileDestination);
		var lPosition = new List();
		if(this._oVolume == null) lPosition.push(this._oMobility.position_get().tile_get()); else {
			lPosition = this._oVolume.tileList_get();
			lPosition = utils_ListTool.merged_get(lPosition,this._oVolume.tileListProject_get(oDestination.x,oDestination.y));
		}
		this._oPathfinder = new mygame_game_utils_PathFinderFlowField(this._oMobility.position_get().map_get(),lPosition,lDestination,($_=this._oPlan,$bind($_,$_.tile_check)));
		if(this._oPathfinder.success_check()) {
			this._oGoal = oDestination.clone();
			if(this._oVolume != null) {
				this._oGoal = mygame_game_ability_Mobility.positionCorrection(this._oMobility,this._oGoal);
				var _g = this._oVolume.tileListProject_get(this._oGoal.x,this._oGoal.y).iterator();
				while(_g.head != null) {
					var oTile;
					oTile = (function($this) {
						var $r;
						_g.val = _g.head[0];
						_g.head = _g.head[1];
						$r = _g.val;
						return $r;
					}(this));
					this._oPathfinder.refTile_set(oTile,oTile);
				}
			}
			this._oGoalTile = this._oMobility.position_get().map_get().tile_get_byUnitMetric(this._oGoal.x,this._oGoal.y);
		} else {
			console.log("[ERROR]:Guidance:no path found.");
			this._oGoal = null;
			this._oGoalTile = null;
		}
	}
	,process: function() {
		if(this._oGoal != null && this._oGoal.equal(this._oMobility.position_get())) this._oGoal = null;
		if(this._oGoal == null) {
			this._oMobility.force_set("Guidance",0,0,true);
			return;
		}
		var oVector = this._vector_get();
		this._oMobility.force_set("Guidance",oVector.x,oVector.y,true);
	}
	,_vector_get: function() {
		var oTileOrigin = null;
		var oTileTargeted = null;
		if(this._oVolume == null) {
			var oTilePosition = this._oMobility.position_get().tile_get();
			oTileTargeted = this._oPathfinder.refTile_get(oTilePosition);
			if(oTileTargeted == oTilePosition) return new space_Vector2i(this._oGoal.x - this._oMobility.position_get().x,this._oGoal.y - this._oMobility.position_get().y);
		} else {
			var lTile = this._oVolume.tileList_get();
			var b = true;
			var _g_head = lTile.h;
			var _g_val = null;
			while(_g_head != null) {
				var oTile;
				oTile = (function($this) {
					var $r;
					_g_val = _g_head[0];
					_g_head = _g_head[1];
					$r = _g_val;
					return $r;
				}(this));
				if(oTile != this._oPathfinder.refTile_get(oTile)) {
					b = false;
					break;
				}
			}
			if(b) return new space_Vector2i(this._oGoal.x - this._oMobility.position_get().x,this._oGoal.y - this._oMobility.position_get().y);
			var _g = lTile.length;
			switch(_g) {
			case 1:
				oTileTargeted = this._oPathfinder.refTile_get(lTile.first());
				break;
			case 2:case 4:
				if(this._pathAssociated_check(this._oPathfinder,lTile)) {
					var heatBest = -1;
					var heatCurrent = null;
					var _g1_head = lTile.h;
					var _g1_val = null;
					while(_g1_head != null) {
						var oTile1;
						oTile1 = (function($this) {
							var $r;
							_g1_val = _g1_head[0];
							_g1_head = _g1_head[1];
							$r = _g1_val;
							return $r;
						}(this));
						heatCurrent = this._oPathfinder.heat_get_byTile(oTile1);
						if(heatCurrent > heatBest) {
							heatBest = heatCurrent;
							oTileOrigin = oTile1;
						}
					}
					oTileTargeted = this._oPathfinder.refTile_get(oTileOrigin);
				} else {
					var heatBest1 = 100000;
					var heatCurrent1 = null;
					var _g1_head1 = lTile.h;
					var _g1_val1 = null;
					while(_g1_head1 != null) {
						var oTile2;
						oTile2 = (function($this) {
							var $r;
							_g1_val1 = _g1_head1[0];
							_g1_head1 = _g1_head1[1];
							$r = _g1_val1;
							return $r;
						}(this));
						heatCurrent1 = this._oPathfinder.heat_get_byTile(oTile2);
						if(heatCurrent1 < heatBest1) {
							heatBest1 = heatCurrent1;
							oTileTargeted = oTile2;
						}
					}
				}
				break;
			default:
				throw new js__$Boot_HaxeError("what?! abnormal volume");
			}
		}
		if(oTileTargeted == null) throw new js__$Boot_HaxeError("[ERROR]:pathfinder : wandering unit");
		var oTileTargetedRef = this._oPathfinder.refTile_get(oTileTargeted);
		var v1 = new space_Vector2i(oTileTargeted.x_get() * 10000 + 5000 - this._oMobility.position_get().x,oTileTargeted.y_get() * 10000 + 5000 - this._oMobility.position_get().y);
		var v2 = null;
		if(oTileTargeted == oTileTargetedRef) v2 = new space_Vector2i(this._oGoal.x - this._oMobility.position_get().x,this._oGoal.y - this._oMobility.position_get().y); else v2 = new space_Vector2i(oTileTargetedRef.x_get() * 10000 + 5000 - this._oMobility.position_get().x,oTileTargetedRef.y_get() * 10000 + 5000 - this._oMobility.position_get().y);
		var fV2Length = v2.length_get();
		var fProjMult = v1.dotProduct(v2) / (fV2Length * fV2Length);
		var v3;
		if(fProjMult > 0) v3 = v2.clone().mult(fProjMult); else v3 = v2.clone();
		v3.add(this._oMobility.position_get().x,this._oMobility.position_get().y);
		if(oTileOrigin != oTileTargeted) {
			if(this._oVolume == null) v3.set(utils_IntTool.max(utils_IntTool.min(v3.x,oTileTargeted.x_get() * 10000 + 9999),oTileTargeted.x_get() * 10000),utils_IntTool.max(utils_IntTool.min(v3.y,oTileTargeted.y_get() * 10000 + 9999),oTileTargeted.y_get() * 10000)); else {
				var fSize = this._oVolume.size_get();
				v3.set(utils_IntTool.max(utils_IntTool.min(v3.x,oTileTargeted.x_get() * 10000 + 9999 - fSize),oTileTargeted.x_get() * 10000 + fSize),utils_IntTool.max(utils_IntTool.min(v3.y,oTileTargeted.y_get() * 10000 + 9999 - fSize),oTileTargeted.y_get() * 10000 + fSize));
			}
		}
		v3.add(-this._oMobility.position_get().x,-this._oMobility.position_get().y);
		if(!isFinite(v3.x) || !isFinite(v3.y)) throw new js__$Boot_HaxeError("[ERROR]:Guidance:invalide vector:" + Std.string(v3));
		return v3;
	}
	,_pathAssociated_check: function(oPathfinder,lTile) {
		var i = 0;
		var _g_head = lTile.h;
		var _g_val = null;
		while(_g_head != null) {
			var oTile;
			oTile = (function($this) {
				var $r;
				_g_val = _g_head[0];
				_g_head = _g_head[1];
				$r = _g_val;
				return $r;
			}(this));
			var oTileRef = oPathfinder.refTile_get(oTile);
			var _g_head1 = lTile.h;
			var _g_val1 = null;
			while(_g_head1 != null) {
				var oTileTmp;
				oTileTmp = (function($this) {
					var $r;
					_g_val1 = _g_head1[0];
					_g_head1 = _g_head1[1];
					$r = _g_val1;
					return $r;
				}(this));
				if(oTileTmp == oTileRef) i++;
				if(oPathfinder.refTile_get(oTileTmp) == oTileRef) i++;
			}
		}
		return i >= lTile.length - 1;
	}
	,__class__: mygame_game_ability_Guidance
});
var mygame_game_ability_GuidancePlatoon = function(oUnit) {
	mygame_game_ability_Guidance.call(this,oUnit);
};
$hxClasses["mygame.game.ability.GuidancePlatoon"] = mygame_game_ability_GuidancePlatoon;
mygame_game_ability_GuidancePlatoon.__name__ = ["mygame","game","ability","GuidancePlatoon"];
mygame_game_ability_GuidancePlatoon.__super__ = mygame_game_ability_Guidance;
mygame_game_ability_GuidancePlatoon.prototype = $extend(mygame_game_ability_Guidance.prototype,{
	goal_set: function(oDestination) {
		mygame_game_ability_Guidance.prototype.goal_set.call(this,oDestination);
		if(this._oGoal == null) return;
		var oPlatoon = this._oUnit.ability_get(mygame_game_ability_Platoon);
		if(oPlatoon == null) throw new js__$Boot_HaxeError("Error");
		var oVolume = this._oUnit.ability_get(mygame_game_ability_Volume);
		if(oVolume == null) throw new js__$Boot_HaxeError("Error");
		var aUnit = oPlatoon.subUnit_get();
		var _g1 = 0;
		var _g = aUnit.length;
		while(_g1 < _g) {
			var i = _g1++;
			var oGuidance = aUnit[i].ability_get(mygame_game_ability_Guidance);
			if(oGuidance == null) continue;
			var oOffset = oPlatoon.offset_get(i);
			if(this._oGoal != null) {
				oOffset = oPlatoon.offset_get(i);
				oOffset.mult(oVolume.size_get());
				oOffset.vector_add(this._oGoal);
				oOffset.add(-oVolume.size_get(),-oVolume.size_get());
			}
			oGuidance.goal_set(oOffset);
		}
	}
	,__class__: mygame_game_ability_GuidancePlatoon
});
var mygame_game_ability_Health = function(oUnit,bArmored,fMax,fCurrent) {
	if(fCurrent == null) fCurrent = 100;
	if(fMax == null) fMax = 100;
	if(bArmored == null) bArmored = false;
	mygame_game_ability_UnitAbility.call(this,oUnit);
	this._fCurrent = fCurrent;
	this._fMax = fMax;
	this._bArmored = bArmored;
	this.onUpdate = new trigger_EventDispatcherTree(oUnit.mygame_get().onHealthAnyUpdate);
};
$hxClasses["mygame.game.ability.Health"] = mygame_game_ability_Health;
mygame_game_ability_Health.__name__ = ["mygame","game","ability","Health"];
mygame_game_ability_Health.__super__ = mygame_game_ability_UnitAbility;
mygame_game_ability_Health.prototype = $extend(mygame_game_ability_UnitAbility.prototype,{
	get: function() {
		return this._fCurrent;
	}
	,max_get: function() {
		return this._fMax;
	}
	,armored_check: function() {
		return this._bArmored;
	}
	,max_set: function(fHealthMax) {
		this._fMax = fHealthMax;
		this.onUpdate.dispatch(this);
	}
	,set: function(fHealthCurrent) {
		this._fCurrent = Math.min(Math.max(fHealthCurrent,0),this._fMax);
		this.onUpdate.dispatch(this);
	}
	,percent_set: function(fPercent) {
		this.set(fPercent * this._fMax);
	}
	,percent_get: function() {
		return this._fCurrent / this._fMax;
	}
	,damage: function(fDamage,eDamageType) {
		if(this._bArmored && eDamageType == mygame_game_misc_weapon_EDamageType.Bullet) return;
		this.set(this.get() - fDamage);
	}
	,__class__: mygame_game_ability_Health
});
var space_Vector2i = function(x_,y_) {
	if(y_ == null) y_ = 0;
	if(x_ == null) x_ = 0;
	this.set(x_,y_);
};
$hxClasses["space.Vector2i"] = space_Vector2i;
space_Vector2i.__name__ = ["space","Vector2i"];
space_Vector2i.distance = function(v1,v2) {
	var dx = v1.x - v2.x;
	var dy = v1.y - v2.y;
	return Math.round(Math.sqrt(dx * dx + dy * dy));
};
space_Vector2i.prototype = {
	clone: function() {
		return new space_Vector2i(this.x,this.y);
	}
	,copy: function(oVector) {
		return this.set(oVector.x,oVector.y);
	}
	,length_get: function() {
		return Math.sqrt(this.x * this.x + this.y * this.y);
	}
	,dotProduct: function(v) {
		return this.x * v.x + this.y * v.y;
	}
	,set: function(x_,y_) {
		if(y_ == null) y_ = 0;
		this.x = x_;
		this.y = y_;
		return this;
	}
	,add: function(x_,y_) {
		if(y_ == null) y_ = 0;
		this.x += x_;
		this.y += y_;
		return this;
	}
	,vector_add: function(oVector) {
		return this.add(oVector.x,oVector.y);
	}
	,mult: function(fMultiplicator) {
		this.x = Math.round(this.x * fMultiplicator);
		this.y = Math.round(this.y * fMultiplicator);
		return this;
	}
	,divide: function(fDivisor) {
		if(fDivisor == 0) throw new js__$Boot_HaxeError("[ERROR] Vector3 : can not divide by 0.");
		return this.mult(Math.round(1 / fDivisor));
	}
	,normalize: function() {
		this.divide(this.length_get());
		return this;
	}
	,length_set: function(fLength) {
		if(fLength < 0) throw new js__$Boot_HaxeError("Invalid length : " + fLength);
		var length = this.length_get();
		if(length == 0) this.x = Math.round(fLength); else this.mult(fLength / length);
		return this;
	}
	,project: function(oVector) {
		var fDotprod = oVector.dotProduct(this);
		this.copy(oVector).length_set(Math.abs(fDotprod) / oVector.length_get());
		return this;
	}
	,equal: function(oVector) {
		return oVector.x == this.x && oVector.y == this.y;
	}
	,angleAxisXY: function() {
		if(this.x == 0 && this.y == 0) return null;
		return Math.atan2(this.y,this.x);
	}
	,__class__: space_Vector2i
};
var space_Circlei = function(oPosition,iRadius) {
	if(oPosition == null) this._oPosition = new space_Vector2i(); else this._oPosition = oPosition;
	this._fRadius = utils_IntTool.max(iRadius,0);
};
$hxClasses["space.Circlei"] = space_Circlei;
space_Circlei.__name__ = ["space","Circlei"];
space_Circlei.prototype = {
	radius_get: function() {
		return this._fRadius;
	}
	,position_get: function() {
		return this._oPosition;
	}
	,__class__: space_Circlei
};
var utils_IntTool = function() { };
$hxClasses["utils.IntTool"] = utils_IntTool;
utils_IntTool.__name__ = ["utils","IntTool"];
utils_IntTool.min = function(a,b) {
	if(a > b) return b;
	return a;
};
utils_IntTool.max = function(a,b) {
	if(a < b) return b;
	return a;
};
var mygame_game_ability_LoyaltyShift = function(oUnit) {
	mygame_game_ability_UnitAbility.call(this,oUnit);
	this._fLoyalty = 1;
	this._oChallenger = this._oUnit.owner_get();
	if(this._oChallenger == null) this._fLoyalty = 0;
};
$hxClasses["mygame.game.ability.LoyaltyShift"] = mygame_game_ability_LoyaltyShift;
mygame_game_ability_LoyaltyShift.__name__ = ["mygame","game","ability","LoyaltyShift"];
mygame_game_ability_LoyaltyShift.__super__ = mygame_game_ability_UnitAbility;
mygame_game_ability_LoyaltyShift.prototype = $extend(mygame_game_ability_UnitAbility.prototype,{
	area_get: function() {
		mygame_game_ability_LoyaltyShift._oArea.position_get().copy(this._oUnit.ability_get(mygame_game_ability_Position));
		return mygame_game_ability_LoyaltyShift._oArea;
	}
	,loyalty_get: function() {
		return this._fLoyalty;
	}
	,challenger_get: function() {
		return this._oChallenger;
	}
	,test: function() {
		var mCount = new haxe_ds_IntMap();
		var oGame = this._oUnit.game_get();
		var _g = oGame.unitList_get().iterator();
		while(_g.head != null) {
			var oUnit;
			oUnit = (function($this) {
				var $r;
				_g.val = _g.head[0];
				_g.head = _g.head[1];
				$r = _g.val;
				return $r;
			}(this));
			if(this._oUnit == oUnit) continue;
			if(oUnit.ability_get(mygame_game_ability_LoyaltyShifter) == null) continue;
			var oPlayer = oUnit.owner_get();
			if(oPlayer != null) {
				if(this.unit_check(oUnit)) {
					if(mCount.exists(oPlayer.playerId_get())) mCount.set(oPlayer.playerId_get(),mCount.get(oPlayer.playerId_get()) + 1); else mCount.set(oPlayer.playerId_get(),1);
				}
			}
		}
		return mCount;
	}
	,unit_check: function(oUnit) {
		var oPosition = oUnit.ability_get(mygame_game_ability_Position);
		if(oPosition == null) return false;
		if(!collider_CollisionCheckerPostInt.check(this.area_get(),oPosition)) return false;
		return true;
	}
	,process: function() {
		var oGame = this._oUnit.mygame_get();
		if(this._fLoyalty == 0) {
			var mCount = this.test();
			if(!mCount.keys().hasNext()) return;
			var oChallenger = null;
			var oChallengerSecond = null;
			var $it0 = mCount.keys();
			while( $it0.hasNext() ) {
				var iPlayerId = $it0.next();
				if(oChallenger == null) oChallenger = oGame.player_get(iPlayerId); else if(mCount.get(oChallenger.playerId_get()) < mCount.h[iPlayerId]) oChallenger = oGame.player_get(iPlayerId); else if(oChallengerSecond == null) oChallengerSecond = oGame.player_get(iPlayerId); else if(mCount.get(oChallengerSecond.playerId_get()) < mCount.h[iPlayerId]) oChallengerSecond = oGame.player_get(iPlayerId);
			}
			if(oChallenger != null && (oChallengerSecond == null || oChallengerSecond != null && mCount.get(oChallenger.playerId_get()) > mCount.get(oChallengerSecond.playerId_get()))) {
				this._oChallenger = oChallenger;
				if(this._oChallenger != null) this.loyalty_increase();
			}
		} else {
			var mCount1 = this.test();
			if(!mCount1.keys().hasNext()) return;
			var oChallenger1 = null;
			var $it1 = mCount1.keys();
			while( $it1.hasNext() ) {
				var oPlayer = $it1.next();
				if(oChallenger1 == null) oChallenger1 = oGame.player_get(oPlayer); else if(mCount1.get(oChallenger1.playerId_get()) < mCount1.h[oPlayer]) oChallenger1 = oGame.player_get(oPlayer);
			}
			if(oChallenger1 == this._oChallenger) this.loyalty_increase(); else this.loyalty_decrease();
		}
	}
	,loyalty_increase: function() {
		this._fLoyalty += mygame_game_ability_LoyaltyShift._fStep;
		if(this._fLoyalty >= 0.5) this._oUnit.owner_set(this._oChallenger);
		this._fLoyalty = Math.min(this._fLoyalty,1);
	}
	,loyalty_decrease: function() {
		this._fLoyalty -= mygame_game_ability_LoyaltyShift._fStep;
		if(this._fLoyalty < 0.5) this._oUnit.owner_set(null);
		this._fLoyalty = Math.max(this._fLoyalty,0);
	}
	,__class__: mygame_game_ability_LoyaltyShift
});
var mygame_game_ability_LoyaltyShifter = function(oUnit) {
	mygame_game_ability_UnitAbility.call(this,oUnit);
};
$hxClasses["mygame.game.ability.LoyaltyShifter"] = mygame_game_ability_LoyaltyShifter;
mygame_game_ability_LoyaltyShifter.__name__ = ["mygame","game","ability","LoyaltyShifter"];
mygame_game_ability_LoyaltyShifter.__super__ = mygame_game_ability_UnitAbility;
mygame_game_ability_LoyaltyShifter.prototype = $extend(mygame_game_ability_UnitAbility.prototype,{
	__class__: mygame_game_ability_LoyaltyShifter
});
var mygame_game_ability_Mobility = function(oUnit,fSpeed) {
	mygame_game_ability_UnitAbility.call(this,oUnit);
	this._oPosition = oUnit.ability_get(mygame_game_ability_Position);
	this._oPlan = oUnit.ability_get(mygame_game_ability_PositionPlan);
	this._oVolume = oUnit.ability_get(mygame_game_ability_Volume);
	if(this._oPosition == null) console.log("[ERROR]:Mobility require Positione ability.");
	this._fSpeed = fSpeed;
	this._oVelocity = new space_Vector2i(0,0);
	this._fOrientation = 0;
	this._fOrientationSpeed = 0.4;
	this._moForce = new haxe_ds_StringMap();
};
$hxClasses["mygame.game.ability.Mobility"] = mygame_game_ability_Mobility;
mygame_game_ability_Mobility.__name__ = ["mygame","game","ability","Mobility"];
mygame_game_ability_Mobility.positionCorrection = function(oMobility,oPoint) {
	if(oMobility._oPlan == null) return oPoint;
	var oMap = oMobility.position_get().map_get();
	var oVolume = oMobility._oVolume;
	if(oVolume == null) {
		var oTile = oMap.tile_get_byUnitMetric(oPoint.x,oPoint.y);
		if(oMobility._oPlan.tile_check(oTile)) return oPoint;
		return null;
	}
	var lTile = oVolume.tileListProject_get(oPoint.x,oPoint.y);
	var oResult = oPoint.clone();
	var oUnitGeometry = new space_AlignedAxisBox2i(oMobility._oVolume.size_get(),oMobility._oVolume.size_get(),oPoint);
	var oTileGeometry;
	var _g_head = lTile.h;
	var _g_val = null;
	while(_g_head != null) {
		var oTile1;
		oTile1 = (function($this) {
			var $r;
			_g_val = _g_head[0];
			_g_head = _g_head[1];
			$r = _g_val;
			return $r;
		}(this));
		if(oMobility._oPlan.tile_check(oTile1)) continue;
		oTileGeometry = mygame_game_ability_Mobility.tileGeometry_get(oTile1);
		if(!collider_CollisionCheckerPostInt.check(oUnitGeometry,oTileGeometry)) continue;
		var iVolumeSize = 0;
		if(oVolume != null) iVolumeSize = oVolume.size_get();
		var dx = oPoint.x / 10000 - (oTile1.x_get() + 0.5);
		var dy = oPoint.y / 10000 - (oTile1.y_get() + 0.5);
		if(Math.abs(dx) > Math.abs(dy)) {
			if(dx > 0) oResult.x = oTileGeometry.right_get() + 1 + iVolumeSize; else oResult.x = oTileGeometry.left_get() - 1 - iVolumeSize;
		} else if(dy > 0) oResult.y = oTileGeometry.top_get() + 1 + iVolumeSize; else oResult.y = oTileGeometry.bottom_get() - 1 - iVolumeSize;
	}
	return oResult;
};
mygame_game_ability_Mobility.tileGeometry_get = function(oTile) {
	return new space_AlignedAxisBoxAlti(9999,9999,new space_Vector2i(oTile.x_get() * 10000,oTile.y_get() * 10000));
};
mygame_game_ability_Mobility.__super__ = mygame_game_ability_UnitAbility;
mygame_game_ability_Mobility.prototype = $extend(mygame_game_ability_UnitAbility.prototype,{
	position_get: function() {
		return this._oPosition;
	}
	,plan_get: function() {
		return this._oPlan;
	}
	,orientation_get: function() {
		return this._fOrientation;
	}
	,speed_set: function(fSpeed) {
		this._fSpeed = fSpeed;
	}
	,orientationSpeed_set: function(fOrientationSpeed) {
		this._fOrientationSpeed = fOrientationSpeed;
	}
	,force_set: function(sKey,fX,fY,bSpeedLimit) {
		if(bSpeedLimit == null) bSpeedLimit = true;
		this._moForce.set(sKey,{ oVector : new space_Vector2i(fX,fY), bLimit : bSpeedLimit});
	}
	,direction_set: function(oVector) {
		var v = oVector.clone();
		v.length_set(this._fSpeed);
		this._oVelocity.set(v.x,v.y);
	}
	,move: function() {
		this._oVelocity.set(0,0);
		var $it0 = this._moForce.iterator();
		while( $it0.hasNext() ) {
			var oForce = $it0.next();
			var oVector = oForce.oVector.clone();
			if(oForce.bLimit && oVector.length_get() > this._fSpeed) oVector.length_set(this._fSpeed);
			this._oVelocity.add(oVector.x,oVector.y);
		}
		if(this._oVelocity.x == 0 && this._oVelocity.y == 0) return;
		var oVectorOrientation = null;
		if(this._moForce.get("Guidance") != null) {
			oVectorOrientation = this._moForce.get("Guidance").oVector.clone();
			this._orientation_update(oVectorOrientation);
		}
		this._collision_process();
		this._position_set(this._oVelocity.x + this._oPosition.x,this._oVelocity.y + this._oPosition.y);
	}
	,clampAngle: function(a) {
		var b = a;
		while(b >= Math.PI * 2) b -= Math.PI * 2;
		while(b < 0) b += Math.PI * 2;
		b %= Math.PI * 2;
		return b;
	}
	,_position_set: function(fPositionX,fPositionY) {
		this._oPosition.set(fPositionX,fPositionY);
	}
	,_orientation_update: function(oDirection) {
		if(oDirection == null) return;
		var fGoal = oDirection.angleAxisXY();
		if(fGoal == null) return;
		fGoal = this.clampAngle(fGoal);
		if(this._fOrientation != fGoal) {
			var fDelta = fGoal - this._fOrientation;
			if(fDelta == 0) this._fOrientation = fGoal; else {
				var fDirection = 0;
				if(fDelta > Math.PI) fDelta -= Math.PI * 2;
				if(fDelta > 0) fDirection = 1; else fDirection = -1;
				this._fOrientation += fDirection * Math.min(Math.abs(fDelta),this._fOrientationSpeed);
			}
			this._fOrientation %= Math.PI * 2;
		}
	}
	,_collision_process: function() {
		if(this._oPlan == null) return true;
		var oGeometry = null;
		var aX = [this._oPosition.x];
		var aY = [this._oPosition.y];
		if(this._oVolume == null) {
			oGeometry = this._oPosition;
			aX.push(this._oPosition.x - this._oVelocity.x);
			aX.push(this._oPosition.x + this._oVelocity.x);
			aY.push(this._oPosition.y - this._oVelocity.y);
			aY.push(this._oPosition.y + this._oVelocity.y);
		} else {
			oGeometry = this._oVolume.geometry_get();
			aX.push(oGeometry.right_get() - this._oVelocity.x);
			aX.push(oGeometry.right_get() + this._oVelocity.x);
			aX.push(oGeometry.left_get() - this._oVelocity.x);
			aX.push(oGeometry.left_get() + this._oVelocity.x);
			aY.push(oGeometry.bottom_get() - this._oVelocity.y);
			aY.push(oGeometry.bottom_get() + this._oVelocity.y);
			aY.push(oGeometry.top_get() - this._oVelocity.y);
			aY.push(oGeometry.top_get() + this._oVelocity.y);
		}
		var xMin = aX[0];
		var xMax = aX[0];
		var _g = 0;
		while(_g < aX.length) {
			var f = aX[_g];
			++_g;
			xMax = utils_IntTool.max(xMax,f);
			xMin = utils_IntTool.min(xMin,f);
		}
		var yMin = aY[0];
		var yMax = aY[0];
		var _g1 = 0;
		while(_g1 < aY.length) {
			var f1 = aY[_g1];
			++_g1;
			yMax = utils_IntTool.max(yMax,f1);
			yMin = utils_IntTool.min(yMin,f1);
		}
		var loTile = this._oPosition.map_get().tileList_get_byArea(mygame_game_ability_Position.metric_unit_to_maptile(xMin),mygame_game_ability_Position.metric_unit_to_maptile(xMax),mygame_game_ability_Position.metric_unit_to_maptile(yMin),mygame_game_ability_Position.metric_unit_to_maptile(yMax));
		var loTmp = new List();
		var _g_head = loTile.h;
		var _g_val = null;
		while(_g_head != null) {
			var oTile;
			oTile = (function($this) {
				var $r;
				_g_val = _g_head[0];
				_g_head = _g_head[1];
				$r = _g_val;
				return $r;
			}(this));
			if(!this._oPlan.tile_check(oTile)) loTmp.push(oTile);
		}
		loTile = loTmp;
		var oCollisionMin = null;
		var oTileMin = null;
		var _g_head1 = loTile.h;
		var _g_val1 = null;
		while(_g_head1 != null) {
			var oTile1;
			oTile1 = (function($this) {
				var $r;
				_g_val1 = _g_head1[0];
				_g_head1 = _g_head1[1];
				$r = _g_val1;
				return $r;
			}(this));
			var oCollision = collider_CollisionCheckerPriorInt.check(oGeometry,this._oVelocity,mygame_game_ability_Mobility.tileGeometry_get(oTile1),null);
			if(oCollision != null) {
				if(oCollisionMin == null) {
					oCollisionMin = oCollision;
					oTileMin = oTile1;
				} else if(oCollision.time_get() < oCollisionMin.time_get()) {
					oCollisionMin = oCollision;
					oTileMin = oTile1;
				}
			}
		}
		if(oCollisionMin != null && oCollisionMin.time_get() <= 1 && oCollisionMin.time_get() >= 0) {
			this._collision_correct(oCollisionMin);
			return false;
		}
		return true;
	}
	,_collision_correct: function(oCollisionEvent) {
		var fTime = oCollisionEvent.time_get();
		var fTimeBefore = fTime;
		var oVector = oCollisionEvent.velocityA_get();
		if(oVector.x == 0 && oVector.y == 0) throw new js__$Boot_HaxeError("[ERROR]:_collision_correct:Invalid vector");
		var i = 1;
		do {
			var fPres = Math.abs(Math.min(oVector.x == 0?1000000:1 / oVector.x,oVector.y == 0?1000000:1 / oVector.y));
			fTimeBefore = fTime - fPres * i;
			oVector.mult(fTimeBefore);
			i++;
		} while(collider_CollisionCheckerPriorInt.check(oCollisionEvent.shapeA_get(),oCollisionEvent.velocityA_get(),oCollisionEvent.shapeB_get(),oCollisionEvent.VelocityB_get()) != null && i != 100);
		if(i == 100) throw new js__$Boot_HaxeError("[ERROR]:_collision_correct:failed after 100 of attempt");
	}
	,__class__: mygame_game_ability_Mobility
});
var mygame_game_ability__$Mobility_Force = function() { };
$hxClasses["mygame.game.ability._Mobility.Force"] = mygame_game_ability__$Mobility_Force;
mygame_game_ability__$Mobility_Force.__name__ = ["mygame","game","ability","_Mobility","Force"];
mygame_game_ability__$Mobility_Force.prototype = {
	__class__: mygame_game_ability__$Mobility_Force
};
var mygame_game_ability_Platoon = function(oUnit) {
	mygame_game_ability_UnitAbility.call(this,oUnit);
	this._aSubUnit = [];
	var _g = 0;
	while(_g < 9) {
		var i = _g++;
		var oSubPosition = this._oUnit.ability_get(mygame_game_ability_Position).clone();
		switch(i) {
		case 0:
			oSubPosition.add(0,0);
			break;
		case 1:
			oSubPosition.add(-4000,0);
			break;
		case 2:
			oSubPosition.add(4000,0);
			break;
		case 3:
			oSubPosition.add(4000,4000);
			break;
		case 4:
			oSubPosition.add(-4000,-4000);
			break;
		case 5:
			oSubPosition.add(4000,-4000);
			break;
		case 6:
			oSubPosition.add(-4000,4000);
			break;
		case 7:
			oSubPosition.add(0,4000);
			break;
		case 8:
			oSubPosition.add(0,-4000);
			break;
		}
		this._aSubUnit.push(new mygame_game_entity_SubUnit(oUnit,oSubPosition));
	}
	this._oPlatoonGuidance = this._oUnit.ability_get(mygame_game_ability_Guidance);
	if(this._oPlatoonGuidance == null) console.log("[ERROR] unit with platoon ability require GuidancePlatoon");
};
$hxClasses["mygame.game.ability.Platoon"] = mygame_game_ability_Platoon;
mygame_game_ability_Platoon.__name__ = ["mygame","game","ability","Platoon"];
mygame_game_ability_Platoon.__super__ = mygame_game_ability_UnitAbility;
mygame_game_ability_Platoon.prototype = $extend(mygame_game_ability_UnitAbility.prototype,{
	subUnit_get: function() {
		var a = this._aSubUnit.slice();
		var _g = 0;
		while(_g < a.length) {
			var o = a[_g];
			++_g;
			if(o.dispose_check()) HxOverrides.remove(this._aSubUnit,o);
		}
		return this._aSubUnit;
	}
	,offset_get: function(iKey) {
		var iPitch = 3 % this._aSubUnit.length;
		return new space_Vector2i(iKey % iPitch,Math.floor(iKey / iPitch));
	}
	,__class__: mygame_game_ability_Platoon
});
var mygame_game_ability_Position = function(oUnit,oWorldMap,x_,y_) {
	this._oUnit = oUnit;
	this._oWorldMap = oWorldMap;
	space_Vector2i.call(this,x_,y_);
};
$hxClasses["mygame.game.ability.Position"] = mygame_game_ability_Position;
mygame_game_ability_Position.__name__ = ["mygame","game","ability","Position"];
mygame_game_ability_Position.__interfaces__ = [legion_ability_IAbility];
mygame_game_ability_Position.metric_unit_to_maptile = function(i) {
	return Math.floor(i / 10000);
};
mygame_game_ability_Position.metric_unit_to_map = function(i) {
	return i / 10000;
};
mygame_game_ability_Position.metric_unit_to_map_vector = function(oVector) {
	return new space_Vector3(oVector.x / 10000,oVector.y / 10000);
};
mygame_game_ability_Position.metric_map_to_unit = function(i) {
	return i * 10000;
};
mygame_game_ability_Position.metric_map_to_unit_vector = function(oVector) {
	return new space_Vector2i(Math.round(oVector.x * 10000),Math.round(oVector.y * 10000));
};
mygame_game_ability_Position.__super__ = space_Vector2i;
mygame_game_ability_Position.prototype = $extend(space_Vector2i.prototype,{
	set: function(x_,y_) {
		if(y_ == null) y_ = 0;
		this.x = x_;
		this.y = y_;
		this._oTile = this._oWorldMap.tile_get_byUnitMetric(this.x,this.y);
		return this;
	}
	,tile_get: function() {
		return this._oTile;
	}
	,map_get: function() {
		return this._oWorldMap;
	}
	,dispose: function() {
	}
	,unit_get: function() {
		return this._oUnit;
	}
	,mainClassName_get: function() {
		return Type.getClassName(js_Boot.getClass(this));
	}
	,__class__: mygame_game_ability_Position
});
var mygame_game_ability_PositionPlan = function(oUnit,iCodePlan) {
	mygame_game_ability_UnitAbility.call(this,oUnit);
	this._iCodePlan = iCodePlan;
};
$hxClasses["mygame.game.ability.PositionPlan"] = mygame_game_ability_PositionPlan;
mygame_game_ability_PositionPlan.__name__ = ["mygame","game","ability","PositionPlan"];
mygame_game_ability_PositionPlan.isLandWalkable = function(oTile) {
	if(oTile == null) return false;
	if(oTile.type_get() == 0) return false;
	if(oTile.type_get() == 3) return false;
	if(oTile.map_get().game_get().query_get(mygame_game_query_CityTile).data_get(oTile).length != 0) return false;
	return true;
};
mygame_game_ability_PositionPlan.isFootWalkable = function(oTile) {
	if(oTile == null) return false;
	if(oTile.type_get() == 1) return true;
	if(oTile.type_get() == 4) return true;
	if(oTile.type_get() == 2) return true;
	return false;
};
mygame_game_ability_PositionPlan.__super__ = mygame_game_ability_UnitAbility;
mygame_game_ability_PositionPlan.prototype = $extend(mygame_game_ability_UnitAbility.prototype,{
	tile_check: function(oTile) {
		var _g = this._iCodePlan;
		switch(_g) {
		case 0:
			return true;
		case 1:
			return mygame_game_ability_PositionPlan.isLandWalkable(oTile);
		case 2:
			return mygame_game_ability_PositionPlan.isFootWalkable(oTile);
		}
		throw new js__$Boot_HaxeError("Invalid code plan : " + this._iCodePlan);
		return false;
	}
	,__class__: mygame_game_ability_PositionPlan
});
var mygame_game_ability_Volume = function(oUnit,fHalfSize,fWeight) {
	if(fWeight == null) fWeight = 1;
	if(fHalfSize == null) fHalfSize = 2000;
	mygame_game_ability_UnitAbility.call(this,oUnit);
	this._oPosition = oUnit.ability_get(mygame_game_ability_Position);
	if(this._oPosition == null) console.log("[ERROR]:ability dependency not respected.");
	this._fWeight = fWeight;
	this._iHalfSize = fHalfSize;
	if(this._iHalfSize < 0 || this._iHalfSize >= 5000) throw new js__$Boot_HaxeError("invalid volume size.");
	this._oHitBox = new space_AlignedAxisBox2i(this._iHalfSize,this._iHalfSize,this._oPosition);
	this._oVelocity = null;
};
$hxClasses["mygame.game.ability.Volume"] = mygame_game_ability_Volume;
mygame_game_ability_Volume.__name__ = ["mygame","game","ability","Volume"];
mygame_game_ability_Volume.__super__ = mygame_game_ability_UnitAbility;
mygame_game_ability_Volume.prototype = $extend(mygame_game_ability_UnitAbility.prototype,{
	position_get: function() {
		return this._oPosition;
	}
	,size_get: function() {
		return this._iHalfSize;
	}
	,weight_get: function() {
		return this._fWeight;
	}
	,geometry_get: function() {
		return this._oHitBox;
	}
	,tileArray_get: function() {
		var loTile = this._oPosition.map_get().tileList_get_byArea(Math.floor(this._oHitBox.left_get() / 10000),Math.floor(this._oHitBox.right_get() / 10000),Math.floor(this._oHitBox.bottom_get() / 10000),Math.floor(this._oHitBox.top_get() / 10000));
		return loTile;
	}
	,tileList_get: function() {
		var loTile = this._oPosition.map_get().tileList_get_byArea(Math.floor(this._oHitBox.left_get() / 10000),Math.floor(this._oHitBox.right_get() / 10000),Math.floor(this._oHitBox.bottom_get() / 10000),Math.floor(this._oHitBox.top_get() / 10000));
		return loTile;
	}
	,tileListProject_get: function(x,y) {
		var oHitBox = new space_AlignedAxisBox2i(this._oHitBox.halfWidth_get(),this._oHitBox.halfHeight_get(),new space_Vector2i(x,y));
		var loTile = this._oPosition.map_get().tileList_get_byArea(Math.floor(oHitBox.left_get() / 10000),Math.floor(oHitBox.right_get() / 10000),Math.floor(oHitBox.bottom_get() / 10000),Math.floor(oHitBox.top_get() / 10000));
		return loTile;
	}
	,move: function() {
	}
	,__class__: mygame_game_ability_Volume
});
var mygame_game_ability_Weapon = function(oOwner,oType) {
	this._oTarget = null;
	mygame_game_ability_UnitAbility.call(this,oOwner);
	this._oType = oType;
	this._oCooldown = new mygame_game_utils_Timer(this._oUnit.game_get(),this._oType.speed_get(),false);
	this._oCooldown.reset();
	this.onFire = new trigger_EventDispatcher2();
	this._oProcess = this._oUnit.mygame_get().oWeaponProcess;
	this._oProcess.onTargeting.attach(this);
	this._oProcess.onFiring.attach(this);
};
$hxClasses["mygame.game.ability.Weapon"] = mygame_game_ability_Weapon;
mygame_game_ability_Weapon.__name__ = ["mygame","game","ability","Weapon"];
mygame_game_ability_Weapon.__interfaces__ = [trigger_ITrigger];
mygame_game_ability_Weapon.__super__ = mygame_game_ability_UnitAbility;
mygame_game_ability_Weapon.prototype = $extend(mygame_game_ability_UnitAbility.prototype,{
	rangeMax_get: function() {
		return this._oType.rangeMax_get();
	}
	,cooldown_get: function() {
		return this._oCooldown;
	}
	,target_set: function(oTarget) {
		this._oTarget = oTarget;
	}
	,target_suggest: function(oTarget) {
		if(this._oTarget != null || !this.target_check(oTarget)) return false;
		this.target_set(oTarget);
		return true;
	}
	,target_get: function() {
		return this._oTarget;
	}
	,_fire: function() {
		this.onFire.dispatch(this);
		if(this._oTarget == null) return;
		this._oCooldown.reset();
		var oHealth = this._oTarget.ability_get(mygame_game_ability_Health);
		oHealth.damage(this._oType.power_get(),this._oType.damageType_get());
	}
	,target_update: function() {
		if(!this.target_check(this._oTarget)) this.target_set(null);
	}
	,swipe_target: function() {
		this.target_update();
		var _g = 0;
		var _g1 = this._oUnit.mygame_get().entity_get_all();
		while(_g < _g1.length) {
			var oTarget = _g1[_g];
			++_g;
			if(js_Boot.__instanceof(oTarget,mygame_game_entity_Unit)) this.target_suggest(oTarget);
		}
	}
	,target_check: function(oTarget) {
		return this._oType.target_check(this,oTarget);
	}
	,trigger: function(oSource) {
		if(oSource == this._oProcess.onTargeting) this.swipe_target();
		if(oSource == this._oProcess.onFiring) {
			if(this._oCooldown.expired_check()) this._fire();
		}
	}
	,dispose: function() {
		this._oProcess.onTargeting.remove(this);
		this._oProcess.onFiring.remove(this);
		mygame_game_ability_UnitAbility.prototype.dispose.call(this);
	}
	,__class__: mygame_game_ability_Weapon
});
var mygame_game_action_IAction = function() { };
$hxClasses["mygame.game.action.IAction"] = mygame_game_action_IAction;
mygame_game_action_IAction.__name__ = ["mygame","game","action","IAction"];
mygame_game_action_IAction.__interfaces__ = [legion_IAction];
var mygame_game_action_UnitDirectControl = function(oPlayer,oDirection) {
	this._oPlayer = oPlayer;
	this._oDirection = oDirection;
};
$hxClasses["mygame.game.action.UnitDirectControl"] = mygame_game_action_UnitDirectControl;
mygame_game_action_UnitDirectControl.__name__ = ["mygame","game","action","UnitDirectControl"];
mygame_game_action_UnitDirectControl.__interfaces__ = [mygame_game_action_IAction];
mygame_game_action_UnitDirectControl.prototype = {
	direction_get: function() {
		return this._oDirection;
	}
	,exec: function(oGame) {
		var oUnit = oGame.hero_get(this._oPlayer);
		oUnit.ability_get(mygame_game_ability_Mobility).force_set("Direct",this._oDirection.x,this._oDirection.y,true);
		oUnit.ability_remove(mygame_game_ability_Guidance);
	}
	,check: function(oGame) {
		return true;
	}
	,__class__: mygame_game_action_UnitDirectControl
};
var mygame_game_action_UnitOrderBuy = function(oUnit,iOfferIndex) {
	this._oUnit = oUnit;
	this._iOfferIndex = iOfferIndex;
};
$hxClasses["mygame.game.action.UnitOrderBuy"] = mygame_game_action_UnitOrderBuy;
mygame_game_action_UnitOrderBuy.__name__ = ["mygame","game","action","UnitOrderBuy"];
mygame_game_action_UnitOrderBuy.__interfaces__ = [mygame_game_action_IAction];
mygame_game_action_UnitOrderBuy.prototype = {
	unit_get: function() {
		return this._oUnit;
	}
	,offerIndex_get: function() {
		return this._iOfferIndex;
	}
	,exec: function(oGame) {
		if(!this.check(oGame)) throw new js__$Boot_HaxeError("invalid input");
		this._oUnit.ability_get(mygame_game_ability_BuilderFactory).buy(this._iOfferIndex);
	}
	,check: function(oGame) {
		if(this._oUnit.ability_get(mygame_game_ability_BuilderFactory) == null) return false;
		return true;
	}
	,__class__: mygame_game_action_UnitOrderBuy
};
var mygame_game_action_UnitOrderMove = function(oUnit,oDestination) {
	this._oUnit = oUnit;
	this._oDestination = oDestination;
};
$hxClasses["mygame.game.action.UnitOrderMove"] = mygame_game_action_UnitOrderMove;
mygame_game_action_UnitOrderMove.__name__ = ["mygame","game","action","UnitOrderMove"];
mygame_game_action_UnitOrderMove.__interfaces__ = [mygame_game_action_IAction];
mygame_game_action_UnitOrderMove.prototype = {
	unit_get: function() {
		return this._oUnit;
	}
	,direction_get: function() {
		return this._oDestination;
	}
	,exec: function(oGame) {
		if(!this.check(oGame)) throw new js__$Boot_HaxeError("invalid input");
		this._oUnit.ability_get(mygame_game_ability_Guidance).goal_set(this._oDestination);
		if(js_Boot.__instanceof(this._oUnit,mygame_game_entity_PlatoonUnit)) {
		}
	}
	,check: function(oGame) {
		if(this._oUnit.ability_get(mygame_game_ability_Guidance) == null) return false;
		return true;
	}
	,__class__: mygame_game_action_UnitOrderMove
};
var mygame_game_collision_WeaponLayer = function() {
	this._oCollisionEvent = null;
	this._loUnit = new List();
	this.onCollision = new trigger_eventdispatcher_EventDispatcher();
};
$hxClasses["mygame.game.collision.WeaponLayer"] = mygame_game_collision_WeaponLayer;
mygame_game_collision_WeaponLayer.__name__ = ["mygame","game","collision","WeaponLayer"];
mygame_game_collision_WeaponLayer.prototype = {
	add: function(oUnit) {
		this._loUnit.add(oUnit);
	}
	,remove: function(oUnit) {
		this._loUnit.remove(oUnit);
	}
	,collisionEventLast_get: function() {
		return this._oCollisionEvent;
	}
	,collision_check: function() {
		var iCollisionQuantity = 0;
		var _g_head = this._loUnit.h;
		var _g_val = null;
		while(_g_head != null) {
			var oUnit;
			oUnit = (function($this) {
				var $r;
				_g_val = _g_head[0];
				_g_head = _g_head[1];
				$r = _g_val;
				return $r;
			}(this));
			var _g_head1 = this._loUnit.h;
			var _g_val1 = null;
			while(_g_head1 != null) {
				var oTarget;
				oTarget = (function($this) {
					var $r;
					_g_val1 = _g_head1[0];
					_g_head1 = _g_head1[1];
					$r = _g_val1;
					return $r;
				}(this));
				var oWeapon = oUnit.ability_get(mygame_game_ability_Weapon);
				if(oWeapon == null) continue;
				oWeapon.target_suggest(oTarget);
			}
		}
		return iCollisionQuantity;
	}
	,__class__: mygame_game_collision_WeaponLayer
};
var mygame_game_entity_Unit = function(oGame,oOwner,oPosition) {
	legion_entity_Entity.call(this,oGame);
	this._oPlayer = oOwner;
	this._ability_add(new mygame_game_ability_Position(this,oGame.map_get(),oPosition.x,oPosition.y));
};
$hxClasses["mygame.game.entity.Unit"] = mygame_game_entity_Unit;
mygame_game_entity_Unit.__name__ = ["mygame","game","entity","Unit"];
mygame_game_entity_Unit.__super__ = legion_entity_Entity;
mygame_game_entity_Unit.prototype = $extend(legion_entity_Entity.prototype,{
	owner_get: function() {
		return this._oPlayer;
	}
	,owner_set: function(oPlayer) {
		this.onUpdate.dispatch(this);
		this._oPlayer = oPlayer;
	}
	,mygame_get: function() {
		return js_Boot.__cast(this._oGame , mygame_game_MyGame);
	}
	,__class__: mygame_game_entity_Unit
});
var mygame_game_entity_Bazoo = function(oGame,oPlayer,oPosition) {
	mygame_game_entity_Unit.call(this,oGame,oPlayer,oPosition);
	this._ability_add(new mygame_game_ability_PositionPlan(this,2));
	this._ability_add(new mygame_game_ability_Mobility(this,0.05));
	this._ability_add(new mygame_game_ability_Guidance(this));
	this._ability_add(new mygame_game_ability_Weapon(this,oGame.singleton_get(mygame_game_misc_weapon_WeaponTypeBazoo)));
	this._ability_add(new mygame_game_ability_Health(this));
	this._ability_add(new mygame_game_ability_LoyaltyShifter(this));
};
$hxClasses["mygame.game.entity.Bazoo"] = mygame_game_entity_Bazoo;
mygame_game_entity_Bazoo.__name__ = ["mygame","game","entity","Bazoo"];
mygame_game_entity_Bazoo.__super__ = mygame_game_entity_Unit;
mygame_game_entity_Bazoo.prototype = $extend(mygame_game_entity_Unit.prototype,{
	__class__: mygame_game_entity_Bazoo
});
var mygame_game_entity_Building = function(oGame,oPlayer,oTile) {
	mygame_game_entity_Unit.call(this,oGame,oPlayer,new space_Vector2i(oTile.x_get() * 10000 + 5000,oTile.y_get() * 10000 + 5000));
};
$hxClasses["mygame.game.entity.Building"] = mygame_game_entity_Building;
mygame_game_entity_Building.__name__ = ["mygame","game","entity","Building"];
mygame_game_entity_Building.__super__ = mygame_game_entity_Unit;
mygame_game_entity_Building.prototype = $extend(mygame_game_entity_Unit.prototype,{
	__class__: mygame_game_entity_Building
});
var mygame_game_entity_City = function(oGame,oPlayer,oTile) {
	mygame_game_entity_Building.call(this,oGame,oPlayer,oTile);
	this._ability_add(new mygame_game_ability_LoyaltyShift(this));
};
$hxClasses["mygame.game.entity.City"] = mygame_game_entity_City;
mygame_game_entity_City.__name__ = ["mygame","game","entity","City"];
mygame_game_entity_City.__super__ = mygame_game_entity_Building;
mygame_game_entity_City.prototype = $extend(mygame_game_entity_Building.prototype,{
	__class__: mygame_game_entity_City
});
var mygame_game_entity_Copter = function(oGame,oPlayer,oPosition) {
	mygame_game_entity_Unit.call(this,oGame,oPlayer,oPosition);
	this._ability_add(new mygame_game_ability_PositionPlan(this,0));
	this._ability_add(new mygame_game_ability_Mobility(this,0.05));
	this._ability_add(new mygame_game_ability_Volume(this,null,0.1));
	this._ability_add(new mygame_game_ability_Guidance(this));
	this._ability_add(new mygame_game_ability_Weapon(this,oGame.singleton_get(mygame_game_misc_weapon_WeaponTypeBazoo)));
	this._ability_add(new mygame_game_ability_Health(this));
	this._ability_add(new mygame_game_ability_LoyaltyShifter(this));
	this.ability_get(mygame_game_ability_Mobility).orientationSpeed_set(0.05);
};
$hxClasses["mygame.game.entity.Copter"] = mygame_game_entity_Copter;
mygame_game_entity_Copter.__name__ = ["mygame","game","entity","Copter"];
mygame_game_entity_Copter.__super__ = mygame_game_entity_Unit;
mygame_game_entity_Copter.prototype = $extend(mygame_game_entity_Unit.prototype,{
	__class__: mygame_game_entity_Copter
});
var mygame_game_entity_Factory = function(oGame,oPlayer,oTile) {
	mygame_game_entity_Building.call(this,oGame,oPlayer,oTile);
	this._ability_add(new mygame_game_ability_BuilderFactory(this));
};
$hxClasses["mygame.game.entity.Factory"] = mygame_game_entity_Factory;
mygame_game_entity_Factory.__name__ = ["mygame","game","entity","Factory"];
mygame_game_entity_Factory.__super__ = mygame_game_entity_Building;
mygame_game_entity_Factory.prototype = $extend(mygame_game_entity_Building.prototype,{
	__class__: mygame_game_entity_Factory
});
var mygame_game_entity_PlatoonUnit = function(oGame,oOwner,oPosition) {
	mygame_game_entity_Unit.call(this,oGame,oOwner,oPosition);
	this._ability_add(new mygame_game_ability_Volume(this,4000,1));
	this._ability_add(new mygame_game_ability_PositionPlan(this,2));
	this._ability_add(new mygame_game_ability_Mobility(this,0.05));
	var oAbility = new mygame_game_ability_GuidancePlatoon(this);
	this._ability_add(oAbility);
	this._moAbility.set(Type.getClassName(mygame_game_ability_Guidance),oAbility);
	this._ability_add(new mygame_game_ability_Platoon(this));
};
$hxClasses["mygame.game.entity.PlatoonUnit"] = mygame_game_entity_PlatoonUnit;
mygame_game_entity_PlatoonUnit.__name__ = ["mygame","game","entity","PlatoonUnit"];
mygame_game_entity_PlatoonUnit.__super__ = mygame_game_entity_Unit;
mygame_game_entity_PlatoonUnit.prototype = $extend(mygame_game_entity_Unit.prototype,{
	__class__: mygame_game_entity_PlatoonUnit
});
var mygame_game_entity_Player = function(oGame,sName) {
	if(sName == null) sName = "Annonymous";
	legion_entity_Player.call(this,oGame,sName);
	this._iCredit = 30;
};
$hxClasses["mygame.game.entity.Player"] = mygame_game_entity_Player;
mygame_game_entity_Player.__name__ = ["mygame","game","entity","Player"];
mygame_game_entity_Player.__super__ = legion_entity_Player;
mygame_game_entity_Player.prototype = $extend(legion_entity_Player.prototype,{
	credit_get: function() {
		return this._iCredit;
	}
	,credit_add: function(iDelta) {
		this._iCredit += iDelta;
		return this.credit_get();
	}
	,__class__: mygame_game_entity_Player
});
var mygame_game_entity_Soldier = function(oGame,oPlayer,oPosition) {
	mygame_game_entity_Unit.call(this,oGame,oPlayer,oPosition);
	this._ability_add(new mygame_game_ability_PositionPlan(this,2));
	this._ability_add(new mygame_game_ability_Mobility(this,1000));
	this._ability_add(new mygame_game_ability_Guidance(this));
	this._ability_add(new mygame_game_ability_Health(this));
	this._ability_add(new mygame_game_ability_Weapon(this,oGame.singleton_get(mygame_game_misc_weapon_WeaponTypeSoldier)));
	this._ability_add(new mygame_game_ability_LoyaltyShifter(this));
};
$hxClasses["mygame.game.entity.Soldier"] = mygame_game_entity_Soldier;
mygame_game_entity_Soldier.__name__ = ["mygame","game","entity","Soldier"];
mygame_game_entity_Soldier.__super__ = mygame_game_entity_Unit;
mygame_game_entity_Soldier.prototype = $extend(mygame_game_entity_Unit.prototype,{
	__class__: mygame_game_entity_Soldier
});
var mygame_game_entity_SubUnit = function(oParent,oPosition) {
	this._oPlatoon = oParent;
	var oGame = this._oPlatoon.game_get();
	mygame_game_entity_Unit.call(this,oGame,this._oPlatoon.owner_get(),oPosition);
	this._ability_add(new mygame_game_ability_Health(this));
	this._ability_add(new mygame_game_ability_PositionPlan(this,2));
	this._ability_add(new mygame_game_ability_Mobility(this,1000));
	this._ability_add(new mygame_game_ability_Guidance(this));
	this._ability_add(new mygame_game_ability_Weapon(this,oGame.singleton_get(mygame_game_misc_weapon_WeaponTypeSoldier)));
	this._ability_add(new mygame_game_ability_LoyaltyShifter(this));
};
$hxClasses["mygame.game.entity.SubUnit"] = mygame_game_entity_SubUnit;
mygame_game_entity_SubUnit.__name__ = ["mygame","game","entity","SubUnit"];
mygame_game_entity_SubUnit.__super__ = mygame_game_entity_Unit;
mygame_game_entity_SubUnit.prototype = $extend(mygame_game_entity_Unit.prototype,{
	platoon_get: function() {
		return this._oPlatoon;
	}
	,__class__: mygame_game_entity_SubUnit
});
var mygame_game_entity_Tank = function(oGame,oPlayer,oPosition) {
	mygame_game_entity_Unit.call(this,oGame,oPlayer,oPosition);
	this._ability_add(new mygame_game_ability_PositionPlan(this,1));
	this._ability_add(new mygame_game_ability_Volume(this,2000,0.45));
	this._ability_add(new mygame_game_ability_Mobility(this,200));
	this._ability_add(new mygame_game_ability_Guidance(this));
	this._ability_add(new mygame_game_ability_Weapon(this,oGame.singleton_get(mygame_game_misc_weapon_WeaponTypeBazoo)));
	this._ability_add(new mygame_game_ability_Health(this,true));
};
$hxClasses["mygame.game.entity.Tank"] = mygame_game_entity_Tank;
mygame_game_entity_Tank.__name__ = ["mygame","game","entity","Tank"];
mygame_game_entity_Tank.__super__ = mygame_game_entity_Unit;
mygame_game_entity_Tank.prototype = $extend(mygame_game_entity_Unit.prototype,{
	__class__: mygame_game_entity_Tank
});
var mygame_game_entity_WorldMap = function(oGame) {
	this._iSizeY = 10;
	this._iSizeX = 10;
	legion_entity_Entity.call(this,oGame);
};
$hxClasses["mygame.game.entity.WorldMap"] = mygame_game_entity_WorldMap;
mygame_game_entity_WorldMap.__name__ = ["mygame","game","entity","WorldMap"];
mygame_game_entity_WorldMap.load = function(oData,oGame) {
	var oWorldMapTmp = new mygame_game_entity_WorldMap(oGame);
	oWorldMapTmp._iSizeX = oData.iSizeX;
	oWorldMapTmp._iSizeY = oData.iSizeY;
	oWorldMapTmp._aoTile = [];
	var _g1 = 0;
	var _g = oWorldMapTmp._iSizeX;
	while(_g1 < _g) {
		var i = _g1++;
		oWorldMapTmp._aoTile[i] = [];
		var _g3 = 0;
		var _g2 = oWorldMapTmp._iSizeY;
		while(_g3 < _g2) {
			var j = _g3++;
			var _g4 = oData.aoTile[j][i];
			switch(_g4) {
			case 0:
				oWorldMapTmp._aoTile[i][j] = new mygame_game_tile_Sea(oWorldMapTmp,i,j);
				break;
			case 1:
				oWorldMapTmp._aoTile[i][j] = new mygame_game_tile_Grass(oWorldMapTmp,i,j);
				break;
			case 2:
				oWorldMapTmp._aoTile[i][j] = new mygame_game_tile_Forest(oWorldMapTmp,i,j);
				break;
			case 3:
				oWorldMapTmp._aoTile[i][j] = new mygame_game_tile_Mountain(oWorldMapTmp,i,j);
				break;
			case 4:
				oWorldMapTmp._aoTile[i][j] = new mygame_game_tile_Road(oWorldMapTmp,i,j);
				break;
			}
		}
	}
	mygame_game_entity_WorldMap.mirrorY(oWorldMapTmp);
	return oWorldMapTmp;
};
mygame_game_entity_WorldMap.mirrorY = function(oWorldMap) {
	var _g1 = 0;
	var _g = oWorldMap._iSizeX;
	while(_g1 < _g) {
		var i = _g1++;
		var _g3 = 0;
		var _g2 = oWorldMap._iSizeY;
		while(_g3 < _g2) {
			var j = _g3++;
			var oTile = oWorldMap._aoTile[i][j];
			var iSize = oWorldMap.sizeY_get() * 2 - 1;
			oWorldMap._aoTile[i][iSize - j] = new mygame_game_tile_Tile(oWorldMap,i,iSize - j,oTile.z_get(),oTile.type_get());
		}
	}
	oWorldMap._iSizeY *= 2;
};
mygame_game_entity_WorldMap.__super__ = legion_entity_Entity;
mygame_game_entity_WorldMap.prototype = $extend(legion_entity_Entity.prototype,{
	sizeX_get: function() {
		return this._iSizeX;
	}
	,sizeY_get: function() {
		return this._iSizeY;
	}
	,tile_get: function(x,y) {
		if(x < 0 || y < 0 || x >= this._iSizeX || y >= this._iSizeY) return null;
		return this._aoTile[x][y];
	}
	,tile_get_byVector: function(oPosition) {
		return this.tile_get(Math.floor(oPosition.x),Math.floor(oPosition.y));
	}
	,tile_get_byUnitMetric: function(x,y) {
		return this.tile_get(Math.floor(x / 10000),Math.floor(y / 10000));
	}
	,tileList_gather: function(oParent) {
		var loTile = new List();
		loTile.add(oParent);
		var oTile = null;
		var _g = 0;
		while(_g < 8) {
			var i = _g++;
			switch(i) {
			case 0:
				oTile = this.tile_get(oParent.x_get() + 1,oParent.y_get());
				break;
			case 1:
				oTile = this.tile_get(oParent.x_get() + 1,oParent.y_get() + 1);
				break;
			case 2:
				oTile = this.tile_get(oParent.x_get(),oParent.y_get() + 1);
				break;
			case 3:
				oTile = this.tile_get(oParent.x_get() - 1,oParent.y_get() + 1);
				break;
			case 4:
				oTile = this.tile_get(oParent.x_get() - 1,oParent.y_get());
				break;
			case 5:
				oTile = this.tile_get(oParent.x_get() - 1,oParent.y_get() - 1);
				break;
			case 6:
				oTile = this.tile_get(oParent.x_get(),oParent.y_get() - 1);
				break;
			case 7:
				oTile = this.tile_get(oParent.x_get() + 1,oParent.y_get() - 1);
				break;
			}
			if(oTile != null) loTile.add(oTile);
		}
		return loTile;
	}
	,tileList_get_byArea: function(xMin,xMax,yMin,yMax) {
		var loTile = new List();
		var oTile = null;
		var _g1 = xMin;
		var _g = xMax + 1;
		while(_g1 < _g) {
			var x = _g1++;
			var _g3 = yMin;
			var _g2 = yMax + 1;
			while(_g3 < _g2) {
				var y = _g3++;
				oTile = this.tile_get(x,y);
				if(oTile != null) loTile.add(oTile);
			}
		}
		return loTile;
	}
	,__class__: mygame_game_entity_WorldMap
});
var mygame_game_misc_PositionDistance = function() {
	this._iLoop = null;
	this._moDelta = new haxe_ds_IntMap();
};
$hxClasses["mygame.game.misc.PositionDistance"] = mygame_game_misc_PositionDistance;
mygame_game_misc_PositionDistance.__name__ = ["mygame","game","misc","PositionDistance"];
mygame_game_misc_PositionDistance.prototype = {
	delta_get: function(oPosition1,oPosition2) {
		var iId1 = oPosition1.unit_get().identity_get();
		var iId2 = oPosition2.unit_get().identity_get();
		if(this._iLoop != oPosition1.unit_get().mygame_get().loopId_get()) this._moDelta = new haxe_ds_IntMap();
		if(this._moDelta.h[iId1] == null) {
			this._moDelta.set(iId1,new haxe_ds_IntMap());
			this._moDelta.set(iId2,new haxe_ds_IntMap());
		}
		if(this._moDelta.h[iId1].h[iId2] == null) {
			var oVector = oPosition2.clone();
			oVector.vector_add(oPosition1.clone().mult(-1));
			this._moDelta.h[iId1].h[iId2] = oVector;
			oVector.mult(-1);
			this._moDelta.h[iId2].h[iId1] = oVector;
		}
		return this._moDelta.h[iId1].h[iId2];
	}
	,__class__: mygame_game_misc_PositionDistance
};
var mygame_game_misc_weapon_EDamageType = $hxClasses["mygame.game.misc.weapon.EDamageType"] = { __ename__ : ["mygame","game","misc","weapon","EDamageType"], __constructs__ : ["Bullet","Shell","Torpedo","Laser","Flamme"] };
mygame_game_misc_weapon_EDamageType.Bullet = ["Bullet",0];
mygame_game_misc_weapon_EDamageType.Bullet.toString = $estr;
mygame_game_misc_weapon_EDamageType.Bullet.__enum__ = mygame_game_misc_weapon_EDamageType;
mygame_game_misc_weapon_EDamageType.Shell = ["Shell",1];
mygame_game_misc_weapon_EDamageType.Shell.toString = $estr;
mygame_game_misc_weapon_EDamageType.Shell.__enum__ = mygame_game_misc_weapon_EDamageType;
mygame_game_misc_weapon_EDamageType.Torpedo = ["Torpedo",2];
mygame_game_misc_weapon_EDamageType.Torpedo.toString = $estr;
mygame_game_misc_weapon_EDamageType.Torpedo.__enum__ = mygame_game_misc_weapon_EDamageType;
mygame_game_misc_weapon_EDamageType.Laser = ["Laser",3];
mygame_game_misc_weapon_EDamageType.Laser.toString = $estr;
mygame_game_misc_weapon_EDamageType.Laser.__enum__ = mygame_game_misc_weapon_EDamageType;
mygame_game_misc_weapon_EDamageType.Flamme = ["Flamme",4];
mygame_game_misc_weapon_EDamageType.Flamme.toString = $estr;
mygame_game_misc_weapon_EDamageType.Flamme.__enum__ = mygame_game_misc_weapon_EDamageType;
var mygame_game_misc_weapon_IWeaponType = function() { };
$hxClasses["mygame.game.misc.weapon.IWeaponType"] = mygame_game_misc_weapon_IWeaponType;
mygame_game_misc_weapon_IWeaponType.__name__ = ["mygame","game","misc","weapon","IWeaponType"];
mygame_game_misc_weapon_IWeaponType.prototype = {
	__class__: mygame_game_misc_weapon_IWeaponType
};
var mygame_game_misc_weapon_WeaponType = function(eType,fPower,fSpeed,fRangeMax) {
	this._eType = eType;
	this._fPower = fPower;
	this._fRangeMax = fRangeMax;
	this._fSpeed = Math.round(Math.max(1,fSpeed));
};
$hxClasses["mygame.game.misc.weapon.WeaponType"] = mygame_game_misc_weapon_WeaponType;
mygame_game_misc_weapon_WeaponType.__name__ = ["mygame","game","misc","weapon","WeaponType"];
mygame_game_misc_weapon_WeaponType.__interfaces__ = [mygame_game_misc_weapon_IWeaponType];
mygame_game_misc_weapon_WeaponType.prototype = {
	damageType_get: function() {
		return this._eType;
	}
	,power_get: function() {
		return this._fPower;
	}
	,rangeMax_get: function() {
		return this._fRangeMax;
	}
	,speed_get: function() {
		return this._fSpeed;
	}
	,target_check: function(oWeapon,oTarget) {
		if(oTarget == null) return false;
		if(oTarget == oWeapon.unit_get()) return false;
		if(oTarget.game_get() == null) return false;
		if(oWeapon.unit_get().owner_get().alliance_get(oTarget.owner_get()) == "ally") return false;
		if(oTarget.ability_get(mygame_game_ability_Health) == null) return false;
		if(!this._inRange_check(oWeapon,oTarget)) return false;
		return true;
	}
	,_inRange_check: function(oWeapon,oUnit) {
		return space_Vector2i.distance(oWeapon.unit_get().ability_get(mygame_game_ability_Position),oUnit.ability_get(mygame_game_ability_Position)) <= this._fRangeMax;
	}
	,__class__: mygame_game_misc_weapon_WeaponType
};
var mygame_game_misc_weapon_WeaponTypeBazoo = function() {
	mygame_game_misc_weapon_WeaponType.call(this,mygame_game_misc_weapon_EDamageType.Shell,20,20,30000);
};
$hxClasses["mygame.game.misc.weapon.WeaponTypeBazoo"] = mygame_game_misc_weapon_WeaponTypeBazoo;
mygame_game_misc_weapon_WeaponTypeBazoo.__name__ = ["mygame","game","misc","weapon","WeaponTypeBazoo"];
mygame_game_misc_weapon_WeaponTypeBazoo.__super__ = mygame_game_misc_weapon_WeaponType;
mygame_game_misc_weapon_WeaponTypeBazoo.prototype = $extend(mygame_game_misc_weapon_WeaponType.prototype,{
	__class__: mygame_game_misc_weapon_WeaponTypeBazoo
});
var mygame_game_misc_weapon_WeaponTypeSoldier = function() {
	mygame_game_misc_weapon_WeaponType.call(this,mygame_game_misc_weapon_EDamageType.Bullet,10,10,30000);
};
$hxClasses["mygame.game.misc.weapon.WeaponTypeSoldier"] = mygame_game_misc_weapon_WeaponTypeSoldier;
mygame_game_misc_weapon_WeaponTypeSoldier.__name__ = ["mygame","game","misc","weapon","WeaponTypeSoldier"];
mygame_game_misc_weapon_WeaponTypeSoldier.__super__ = mygame_game_misc_weapon_WeaponType;
mygame_game_misc_weapon_WeaponTypeSoldier.prototype = $extend(mygame_game_misc_weapon_WeaponType.prototype,{
	target_check: function(oWeapon,oTarget) {
		if(oTarget == null) return false;
		if(oTarget == oWeapon.unit_get()) return false;
		if(oTarget.game_get() == null) return false;
		if(oWeapon.unit_get().owner_get().alliance_get(oTarget.owner_get()) == "ally") return false;
		var oHealth = oTarget.ability_get(mygame_game_ability_Health);
		if(oHealth == null) return false;
		if(oHealth.armored_check()) return false;
		if(!this._inRange_check(oWeapon,oTarget)) return false;
		return true;
	}
	,__class__: mygame_game_misc_weapon_WeaponTypeSoldier
});
var mygame_game_process_Death = function(oGame) {
	this._oGame = oGame;
	this._lHealth = new List();
	this._oGame.onLoop.attach(this);
	this._oGame.onHealthAnyUpdate.attach(this);
};
$hxClasses["mygame.game.process.Death"] = mygame_game_process_Death;
mygame_game_process_Death.__name__ = ["mygame","game","process","Death"];
mygame_game_process_Death.__interfaces__ = [trigger_ITrigger];
mygame_game_process_Death.prototype = {
	process: function() {
		while(!this._lHealth.isEmpty()) {
			var oHealth = this._lHealth.pop();
			if(oHealth.get() == 0) oHealth.unit_get().dispose();
		}
	}
	,trigger: function(oSource) {
		if(oSource == this._oGame.onLoop) this.process();
		if(oSource == this._oGame.onHealthAnyUpdate) this._lHealth.push(this._oGame.onHealthAnyUpdate.event_get());
	}
	,__class__: mygame_game_process_Death
};
var mygame_game_process_LoyaltyShiftProcess = function(oGame) {
	this._oGame = oGame;
	this._lAbility = new List();
	this._oGame.onLoop.attach(this);
	this._oGame.onEntityNew.attach(this);
	this._oGame.onEntityDispose.attach(this);
};
$hxClasses["mygame.game.process.LoyaltyShiftProcess"] = mygame_game_process_LoyaltyShiftProcess;
mygame_game_process_LoyaltyShiftProcess.__name__ = ["mygame","game","process","LoyaltyShiftProcess"];
mygame_game_process_LoyaltyShiftProcess.__interfaces__ = [trigger_ITrigger];
mygame_game_process_LoyaltyShiftProcess.prototype = {
	process: function() {
		var _g_head = this._lAbility.h;
		var _g_val = null;
		while(_g_head != null) {
			var oAbility;
			oAbility = (function($this) {
				var $r;
				_g_val = _g_head[0];
				_g_head = _g_head[1];
				$r = _g_val;
				return $r;
			}(this));
			oAbility.process();
		}
	}
	,trigger: function(oSource) {
		if(oSource == this._oGame.onLoop) this.process();
		if(oSource == this._oGame.onEntityNew) {
			var oAbility = this._oGame.onEntityNew.event_get().ability_get(mygame_game_ability_LoyaltyShift);
			if(oAbility != null) this._lAbility.push(oAbility);
		}
		if(oSource == this._oGame.onEntityDispose) {
			var oAbility1 = this._oGame.onEntityNew.event_get().ability_get(mygame_game_ability_LoyaltyShift);
			if(oAbility1 != null) this._lAbility.remove(oAbility1);
		}
	}
	,__class__: mygame_game_process_LoyaltyShiftProcess
};
var mygame_game_process_MobilityProcess = function(oGame) {
	this._oGame = oGame;
	this._loUnit = new List();
	this._oGame.onLoop.attach(this);
	this._oGame.onEntityNew.attach(this);
	this._oGame.onEntityDispose.attach(this);
};
$hxClasses["mygame.game.process.MobilityProcess"] = mygame_game_process_MobilityProcess;
mygame_game_process_MobilityProcess.__name__ = ["mygame","game","process","MobilityProcess"];
mygame_game_process_MobilityProcess.__interfaces__ = [trigger_ITrigger];
mygame_game_process_MobilityProcess.prototype = {
	process: function() {
		var lUnitDelete = new List();
		var _g_head = this._loUnit.h;
		var _g_val = null;
		while(_g_head != null) {
			var oUnit;
			oUnit = (function($this) {
				var $r;
				_g_val = _g_head[0];
				_g_head = _g_head[1];
				$r = _g_val;
				return $r;
			}(this));
			var oGuidance = oUnit.ability_get(mygame_game_ability_Guidance);
			if(oGuidance != null) oGuidance.process(); else if(oUnit.ability_get(mygame_game_ability_Mobility) == null) lUnitDelete.push(oUnit);
		}
		var _g_head1 = lUnitDelete.h;
		var _g_val1 = null;
		while(_g_head1 != null) {
			var oUnit1;
			oUnit1 = (function($this) {
				var $r;
				_g_val1 = _g_head1[0];
				_g_head1 = _g_head1[1];
				$r = _g_val1;
				return $r;
			}(this));
			this._loUnit.remove(oUnit1);
		}
		var _g_head2 = this._loUnit.h;
		var _g_val2 = null;
		while(_g_head2 != null) {
			var oUnit2;
			oUnit2 = (function($this) {
				var $r;
				_g_val2 = _g_head2[0];
				_g_head2 = _g_head2[1];
				$r = _g_val2;
				return $r;
			}(this));
			oUnit2.ability_get(mygame_game_ability_Mobility).move();
		}
	}
	,trigger: function(oSource) {
		if(oSource == this._oGame.onLoop) this.process();
		if(oSource == this._oGame.onEntityNew) {
			if(Std["is"](oSource.event_get(),mygame_game_entity_Unit)) {
				var oUnit = oSource.event_get();
				if(oUnit.ability_get(mygame_game_ability_Mobility) != null) this._loUnit.add(oUnit);
			}
		}
		if(oSource == this._oGame.onEntityDispose) this._loUnit.remove(oSource.event_get());
	}
	,__class__: mygame_game_process_MobilityProcess
};
var mygame_game_process_VictoryCondition = function(oGame) {
	this._oGame = oGame;
	this._fVictory = 0;
	this._oChallenger = null;
	this._mObjectif = new haxe_ds_IntMap();
	this._mObjectif.set(0,new List());
	this._mObjectif.set(1,new List());
	this._oGame.onLoop.attach(this);
};
$hxClasses["mygame.game.process.VictoryCondition"] = mygame_game_process_VictoryCondition;
mygame_game_process_VictoryCondition.__name__ = ["mygame","game","process","VictoryCondition"];
mygame_game_process_VictoryCondition.__interfaces__ = [trigger_ITrigger];
mygame_game_process_VictoryCondition.prototype = {
	challenger_get: function() {
		return this._oChallenger;
	}
	,value_get: function() {
		return this._fVictory;
	}
	,_objectifCount_get: function() {
	}
	,process: function() {
		this._init();
		var fDelta = 0;
		var iCountMax = 0;
		var iChallengerIdNew = null;
		var $it0 = this._mObjectif.keys();
		while( $it0.hasNext() ) {
			var iPlayerId = $it0.next();
			var iCount = this._mObjectif.h[iPlayerId].length;
			if(iCount == iCountMax) {
				iChallengerIdNew = null;
				break;
			}
			if(iCount > iCountMax) {
				iCountMax = iCount;
				iChallengerIdNew = iPlayerId;
			}
		}
		this._victory_process(iChallengerIdNew);
		if(this._fVictory > 1) this._oGame.end(this._oChallenger);
	}
	,_victory_process: function(iChallengerIdNew) {
		if(this._oChallenger == null) {
			this._oChallenger = this._oGame.player_get(iChallengerIdNew);
			return;
		}
		if(this._oChallenger.playerId_get() != iChallengerIdNew) {
			if(iChallengerIdNew == null) return;
			if(this._fVictory - 0.001 < 0) {
				this._oChallenger = this._oGame.player_get(iChallengerIdNew);
				return;
			} else {
				this._fVictory -= 0.001;
				return;
			}
		} else {
			this._fVictory += 0.001;
			return;
		}
	}
	,_influence_get: function() {
	}
	,_init: function() {
		this._mObjectif = new haxe_ds_IntMap();
		var _g = 0;
		var _g1 = this._oGame.entity_get_all();
		while(_g < _g1.length) {
			var oEntity = _g1[_g];
			++_g;
			var oLoyaltyShift = oEntity.ability_get(mygame_game_ability_LoyaltyShift);
			if(oLoyaltyShift != null) {
				var oUnit = oEntity;
				var oPlayer = oUnit.owner_get();
				if(oPlayer != null) {
					if(!this._mObjectif.exists(oPlayer.playerId_get())) this._mObjectif.set(oPlayer.playerId_get(),new List());
					this._mObjectif.get(oPlayer.playerId_get()).add(oUnit);
				}
			}
		}
	}
	,trigger: function(oSource) {
		if(oSource == this._oGame.onLoop) this.process();
		if(oSource == this._oGame.onEntityNew) {
		}
		if(oSource == this._oGame.onEntityUpdate) {
			if(Std["is"](this._oGame.onEntityUpdate.event_get(),mygame_game_entity_Unit)) {
				var oLoyaltyShift = this._oGame.onEntityUpdate.event_get().ability_get(mygame_game_ability_LoyaltyShift);
				if(oLoyaltyShift != null) {
					var oUnit = oLoyaltyShift.unit_get();
					var $it0 = this._mObjectif.iterator();
					while( $it0.hasNext() ) {
						var lObjectif = $it0.next();
						lObjectif.remove(oUnit);
					}
					this._mObjectif.get(oUnit.owner_get().playerId_get()).add(oUnit);
				}
			}
		}
	}
	,__class__: mygame_game_process_VictoryCondition
};
var mygame_game_process_VolumeEjection = function(oGame) {
	this._oGame = oGame;
	this._oGame.onLoop.attach(this);
	this._oGame.onEntityNew.attach(this);
	this._oGame.onAbilityDispose.attach(this);
	this._loVolume = new List();
};
$hxClasses["mygame.game.process.VolumeEjection"] = mygame_game_process_VolumeEjection;
mygame_game_process_VolumeEjection.__name__ = ["mygame","game","process","VolumeEjection"];
mygame_game_process_VolumeEjection.__interfaces__ = [trigger_ITrigger];
mygame_game_process_VolumeEjection.prototype = {
	process: function() {
		var _g = this._oGame.unitList_get().iterator();
		while(_g.head != null) {
			var oUnit;
			oUnit = (function($this) {
				var $r;
				_g.val = _g.head[0];
				_g.head = _g.head[1];
				$r = _g.val;
				return $r;
			}(this));
			var oMobility = oUnit.ability_get(mygame_game_ability_Mobility);
			if(oMobility == null) continue;
			oMobility.force_set("volume",0,0,false);
			var _g_head = this._loVolume.h;
			var _g_val = null;
			while(_g_head != null) {
				var oVolume;
				oVolume = (function($this) {
					var $r;
					_g_val = _g_head[0];
					_g_head = _g_head[1];
					$r = _g_val;
					return $r;
				}(this));
				if(oVolume.unit_get() == oUnit) continue;
				var fVolumeSecondSize = 0.0;
				var oVolumeSecond = oUnit.ability_get(mygame_game_ability_Volume);
				if(oVolumeSecond != null) fVolumeSecondSize = oVolumeSecond.size_get();
				var oVector = this._oGame.positionDistance_get().delta_get(oMobility.position_get(),oVolume.position_get());
				if(oVector.length_get() > oVolume.size_get() + fVolumeSecondSize) continue;
				oVector.length_set((oVolume.size_get() + fVolumeSecondSize - oVector.length_get()) * 0.5);
				oMobility.force_set("volume",oVector.x,oVector.y,false);
			}
		}
	}
	,trigger: function(oSource) {
		if(oSource == this._oGame.onLoop) this.process();
		if(oSource == this._oGame.onEntityNew) {
			var oVolume = (js_Boot.__cast(oSource.event_get() , legion_entity_Entity)).ability_get(mygame_game_ability_Volume);
			if(oVolume != null) this._loVolume.push(oVolume);
		}
		if(oSource == this._oGame.onAbilityDispose && Std["is"](oSource.event_get(),mygame_game_ability_Volume)) {
			var oVolume1;
			oVolume1 = js_Boot.__cast(oSource.event_get() , mygame_game_ability_Volume);
			this._loVolume.remove(oVolume1);
		}
	}
	,__class__: mygame_game_process_VolumeEjection
};
var mygame_game_process_WeaponProcess = function(oGame) {
	this._oGame = oGame;
	this._lWeapon = new List();
	this.onTargeting = new trigger_EventDispatcher2();
	this.onFiring = new trigger_EventDispatcher2();
	this._oGame.onLoop.attach(this);
};
$hxClasses["mygame.game.process.WeaponProcess"] = mygame_game_process_WeaponProcess;
mygame_game_process_WeaponProcess.__name__ = ["mygame","game","process","WeaponProcess"];
mygame_game_process_WeaponProcess.__interfaces__ = [trigger_ITrigger];
mygame_game_process_WeaponProcess.prototype = {
	entity_add: function(oEntity) {
		if(js_Boot.__instanceof(oEntity,mygame_game_entity_Unit)) {
			var oUnit = oEntity;
			var oWeapon = oUnit.ability_get(mygame_game_ability_Weapon);
			if(oWeapon != null) this._lWeapon.push(oWeapon);
			return true;
		}
		return false;
	}
	,trigger: function(oSource) {
		if(oSource == this._oGame.onLoop) {
			this.onTargeting.dispatch(this._oGame);
			this.onFiring.dispatch(this._oGame);
		}
	}
	,__class__: mygame_game_process_WeaponProcess
};
var mygame_game_query_CityTile = function(oGame) {
	this._oGame = oGame;
	this._oCache = new haxe_ds_StringMap();
};
$hxClasses["mygame.game.query.CityTile"] = mygame_game_query_CityTile;
mygame_game_query_CityTile.__name__ = ["mygame","game","query","CityTile"];
mygame_game_query_CityTile.__interfaces__ = [legion_IQuery];
mygame_game_query_CityTile.prototype = {
	data_get: function(oTile) {
		var s = oTile.x_get() + ";" + oTile.y_get();
		if(this._oCache.exists(s)) return this._oCache.get(s);
		this._oCache.set(s,new List());
		var _g = 0;
		var _g1 = this._oGame.entity_get_all();
		while(_g < _g1.length) {
			var oUnit = _g1[_g];
			++_g;
			if(js_Boot.__instanceof(oUnit,mygame_game_entity_City) && oUnit.ability_get(mygame_game_ability_Position).tile_get() == oTile) this._oCache.get(s).add(oTile);
		}
		return this._oCache.get(s);
	}
	,__class__: mygame_game_query_CityTile
};
var mygame_game_query_UnitDist = function(oGame) {
	this._iLoop = -1;
	this._oGame = oGame;
	this._oCache = new haxe_ds_StringMap();
};
$hxClasses["mygame.game.query.UnitDist"] = mygame_game_query_UnitDist;
mygame_game_query_UnitDist.__name__ = ["mygame","game","query","UnitDist"];
mygame_game_query_UnitDist.__interfaces__ = [legion_IQuery];
mygame_game_query_UnitDist.prototype = {
	data_get: function(aUnit) {
		if(aUnit.length != 2) throw new js__$Boot_HaxeError("Invalid parameter");
		var oPos0 = aUnit[0].ability_get(mygame_game_ability_Position);
		var oPos1 = aUnit[1].ability_get(mygame_game_ability_Position);
		if(oPos0 == null || oPos1 == null) throw new js__$Boot_HaxeError("Missing position ability");
		this._cache_update();
		var sKey = aUnit[0].identity_get() + ";" + aUnit[1].identity_get();
		if(this._oCache.exists(sKey)) return this._oCache.get(sKey);
		var fResult = space_Vector2i.distance(oPos0,oPos1);
		this._oCache.set(sKey,fResult);
		return fResult;
	}
	,_cache_update: function() {
		if(this._iLoop == this._oGame.loopId_get()) return;
		this._iLoop == this._oGame.loopId_get();
		this._oCache = new haxe_ds_StringMap();
	}
	,__class__: mygame_game_query_UnitDist
};
var mygame_game_query_UnitQuery = function(oGame) {
	this._iLoop = -1;
	this._oGame = oGame;
	this._oCache = new haxe_ds_StringMap();
};
$hxClasses["mygame.game.query.UnitQuery"] = mygame_game_query_UnitQuery;
mygame_game_query_UnitQuery.__name__ = ["mygame","game","query","UnitQuery"];
mygame_game_query_UnitQuery.__interfaces__ = [legion_IQuery];
mygame_game_query_UnitQuery.prototype = {
	data_get: function(aUnit) {
		this._oFilter = aUnit;
		var lUnit = new List();
		var _g = 0;
		var _g1 = this._oGame.entity_get_all();
		while(_g < _g1.length) {
			var oUnit = _g1[_g];
			++_g;
			if(!js_Boot.__instanceof(oUnit,mygame_game_entity_Unit)) continue;
			if(!this._test(oUnit)) continue;
			lUnit.add(oUnit);
		}
		return lUnit;
	}
	,_cache_update: function() {
		if(this._iLoop == this._oGame.loopId_get()) return;
		this._iLoop == this._oGame.loopId_get();
		this._oCache = new haxe_ds_StringMap();
	}
	,_test: function(oUnit) {
		if(this._oFilter.exists("type")) {
			var _oType = this._oFilter.get("type");
			if(!js_Boot.__instanceof(oUnit,_oType)) return false;
		}
		if(this._oFilter.exists("ability")) {
			var _oType1 = this._oFilter.get("ability");
			if(oUnit.ability_get(_oType1) == null) return false;
		}
		if(this._oFilter.exists("owner")) {
			var _oPlayer = this._oFilter.get("owner");
			if(oUnit.owner_get() != _oPlayer) return false;
		}
		return true;
	}
	,__class__: mygame_game_query_UnitQuery
};
var space_IAlignedAxisBox = function() { };
$hxClasses["space.IAlignedAxisBox"] = space_IAlignedAxisBox;
space_IAlignedAxisBox.__name__ = ["space","IAlignedAxisBox"];
space_IAlignedAxisBox.prototype = {
	__class__: space_IAlignedAxisBox
};
var space_AlignedAxisBoxAlt = function(fWidth,fHeight,oBottomLeft) {
	this._fWidth = fWidth;
	this._fHeight = fHeight;
	if(oBottomLeft == null) this._oBottomLeft = new space_Vector3(); else this._oBottomLeft = oBottomLeft;
};
$hxClasses["space.AlignedAxisBoxAlt"] = space_AlignedAxisBoxAlt;
space_AlignedAxisBoxAlt.__name__ = ["space","AlignedAxisBoxAlt"];
space_AlignedAxisBoxAlt.__interfaces__ = [space_IAlignedAxisBox];
space_AlignedAxisBoxAlt.prototype = {
	center_get: function() {
		return new space_Vector3(this._oBottomLeft.x + this.halfWidth_get(),this._oBottomLeft.y + this.halfHeight_get());
	}
	,width_get: function() {
		return this._fWidth;
	}
	,height_get: function() {
		return this._fHeight;
	}
	,halfWidth_get: function() {
		return this._fWidth / 2;
	}
	,halfHeight_get: function() {
		return this._fHeight / 2;
	}
	,top_get: function() {
		return this._oBottomLeft.y + this._fHeight;
	}
	,bottom_get: function() {
		return this._oBottomLeft.y;
	}
	,right_get: function() {
		return this._oBottomLeft.x + this._fWidth;
	}
	,left_get: function() {
		return this._oBottomLeft.x;
	}
	,bottomLeft_set: function(x,y) {
		this._oBottomLeft.set(x,y);
	}
	,__class__: space_AlignedAxisBoxAlt
};
var space_Vector3 = function(x_,y_,z_) {
	if(z_ == null) z_ = 0;
	if(y_ == null) y_ = 0;
	if(x_ == null) x_ = 0;
	this.set(x_,y_,z_);
};
$hxClasses["space.Vector3"] = space_Vector3;
space_Vector3.__name__ = ["space","Vector3"];
space_Vector3.distance = function(v1,v2) {
	var dx = v1.x - v2.x;
	var dy = v1.y - v2.y;
	var dz = v1.z - v2.z;
	return Math.sqrt(dx * dx + dy * dy + dz * dz);
};
space_Vector3.prototype = {
	clone: function() {
		return new space_Vector3(this.x,this.y,this.z);
	}
	,copy: function(oVector) {
		this.set(oVector.x,oVector.y,oVector.z);
	}
	,set: function(x_,y_,z_) {
		if(z_ == null) z_ = 0;
		if(y_ == null) y_ = 0;
		this.x = x_;
		this.y = y_;
		this.z = z_;
		return this;
	}
	,add: function(x_,y_,z_) {
		if(z_ == null) z_ = 0;
		if(y_ == null) y_ = 0;
		if(x_ == null) x_ = 0;
		this.x += x_;
		this.y += y_;
		this.z += z_;
		return this;
	}
	,mult: function(fMultiplicator) {
		this.x *= fMultiplicator;
		this.y *= fMultiplicator;
		this.z *= fMultiplicator;
	}
	,divide: function(fDivisor) {
		if(fDivisor != 0) this.mult(1 / fDivisor); else throw new js__$Boot_HaxeError("[ERROR] Vector3 : can not divide by 0.");
	}
	,normalize: function() {
		this.divide(this.length_get());
		return this;
	}
	,length_set: function(fLength) {
		if(fLength < 0) throw new js__$Boot_HaxeError("Invalid length : " + fLength);
		var length = this.length_get();
		if(length == 0) this.x = fLength; else this.mult(fLength / length);
		return this;
	}
	,length_get: function() {
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
	}
	,dotProduct: function(v) {
		return this.x * v.x + this.y * v.y + this.z * v.z;
	}
	,vector3_add: function(oVector) {
		this.add(oVector.x,oVector.y,oVector.z);
	}
	,vector3_sub: function(oVector) {
		this.add(-oVector.x,-oVector.y,-oVector.z);
	}
	,angleAxisXY: function() {
		if(this.x == 0 && this.y == 0) return null;
		return Math.atan2(this.y,this.x);
	}
	,__class__: space_Vector3
};
var mygame_game_tile_Tile = function(oMap,x,y,z,iType) {
	this._x = x;
	this._y = y;
	this._z = z;
	this._iType = iType;
	this._oMap = oMap;
};
$hxClasses["mygame.game.tile.Tile"] = mygame_game_tile_Tile;
mygame_game_tile_Tile.__name__ = ["mygame","game","tile","Tile"];
mygame_game_tile_Tile.prototype = {
	x_get: function() {
		return this._x;
	}
	,y_get: function() {
		return this._y;
	}
	,z_get: function() {
		return this._z;
	}
	,type_get: function() {
		return this._iType;
	}
	,map_get: function() {
		return this._oMap;
	}
	,neighborList_get: function() {
		var loTile = new List();
		var oTile = null;
		var _g = 0;
		while(_g < 4) {
			var i = _g++;
			switch(i) {
			case 0:
				oTile = this._oMap.tile_get(this.x_get() + 1,this.y_get());
				break;
			case 1:
				oTile = this._oMap.tile_get(this.x_get() - 1,this.y_get());
				break;
			case 2:
				oTile = this._oMap.tile_get(this.x_get(),this.y_get() + 1);
				break;
			case 3:
				oTile = this._oMap.tile_get(this.x_get(),this.y_get() - 1);
				break;
			}
			if(oTile != null) loTile.push(oTile);
		}
		return loTile;
	}
	,__class__: mygame_game_tile_Tile
};
var mygame_game_tile_Forest = function(oMap,x,y) {
	mygame_game_tile_Tile.call(this,oMap,x,y,2,2);
};
$hxClasses["mygame.game.tile.Forest"] = mygame_game_tile_Forest;
mygame_game_tile_Forest.__name__ = ["mygame","game","tile","Forest"];
mygame_game_tile_Forest.__super__ = mygame_game_tile_Tile;
mygame_game_tile_Forest.prototype = $extend(mygame_game_tile_Tile.prototype,{
	__class__: mygame_game_tile_Forest
});
var mygame_game_tile_Grass = function(oMap,x,y) {
	mygame_game_tile_Tile.call(this,oMap,x,y,2,1);
};
$hxClasses["mygame.game.tile.Grass"] = mygame_game_tile_Grass;
mygame_game_tile_Grass.__name__ = ["mygame","game","tile","Grass"];
mygame_game_tile_Grass.__super__ = mygame_game_tile_Tile;
mygame_game_tile_Grass.prototype = $extend(mygame_game_tile_Tile.prototype,{
	__class__: mygame_game_tile_Grass
});
var mygame_game_tile_Mountain = function(oMap,x,y) {
	mygame_game_tile_Tile.call(this,oMap,x,y,2,3);
};
$hxClasses["mygame.game.tile.Mountain"] = mygame_game_tile_Mountain;
mygame_game_tile_Mountain.__name__ = ["mygame","game","tile","Mountain"];
mygame_game_tile_Mountain.__super__ = mygame_game_tile_Tile;
mygame_game_tile_Mountain.prototype = $extend(mygame_game_tile_Tile.prototype,{
	__class__: mygame_game_tile_Mountain
});
var mygame_game_tile_Road = function(oMap,x,y) {
	mygame_game_tile_Tile.call(this,oMap,x,y,2,4);
};
$hxClasses["mygame.game.tile.Road"] = mygame_game_tile_Road;
mygame_game_tile_Road.__name__ = ["mygame","game","tile","Road"];
mygame_game_tile_Road.__super__ = mygame_game_tile_Tile;
mygame_game_tile_Road.prototype = $extend(mygame_game_tile_Tile.prototype,{
	__class__: mygame_game_tile_Road
});
var mygame_game_tile_Sea = function(oMap,x,y) {
	mygame_game_tile_Tile.call(this,oMap,x,y,0,0);
	this._z = 0;
};
$hxClasses["mygame.game.tile.Sea"] = mygame_game_tile_Sea;
mygame_game_tile_Sea.__name__ = ["mygame","game","tile","Sea"];
mygame_game_tile_Sea.__super__ = mygame_game_tile_Tile;
mygame_game_tile_Sea.prototype = $extend(mygame_game_tile_Tile.prototype,{
	__class__: mygame_game_tile_Sea
});
var mygame_game_utils_PathFinderFlowField = function(oWorldMap,lPosition,lDestination,pTest) {
	this._oWorldMap = oWorldMap;
	this._aReferenceMap = new haxe_ds_StringMap();
	this._aHeatMap = new haxe_ds_StringMap();
	this._lTileCurrent = new List();
	this._pTest = pTest;
	var _g_head = lDestination.h;
	var _g_val = null;
	while(_g_head != null) {
		var oTile;
		oTile = (function($this) {
			var $r;
			_g_val = _g_head[0];
			_g_head = _g_head[1];
			$r = _g_val;
			return $r;
		}(this));
		this._aReferenceMap.set(this._key_get(oTile),oTile);
		this._aHeatMap.set(this._key_get(oTile),0);
		this._lTileCurrent.push(oTile);
		lPosition.remove(oTile);
	}
	this._bSuccess = this._referenceMap_update(lPosition);
};
$hxClasses["mygame.game.utils.PathFinderFlowField"] = mygame_game_utils_PathFinderFlowField;
mygame_game_utils_PathFinderFlowField.__name__ = ["mygame","game","utils","PathFinderFlowField"];
mygame_game_utils_PathFinderFlowField.prototype = {
	worldmap_get: function() {
		return this._oWorldMap;
	}
	,success_check: function() {
		return this._bSuccess;
	}
	,refTile_getbyCoord: function(x,y) {
		if(this._aReferenceMap == null) return null;
		return this._aReferenceMap.get(x + ";" + y);
	}
	,refTile_get: function(oTile) {
		if(this._aReferenceMap == null) return null;
		this._update(oTile);
		return this._aReferenceMap.get(this._key_get(oTile));
	}
	,heat_get_byTile: function(oTile) {
		if(oTile == null) return 1073741823;
		this._update(oTile);
		return this._aHeatMap.get(this._key_get(oTile));
	}
	,refTile_set: function(oTile,oTileRef) {
		if(this._aReferenceMap.get(this._key_get(oTile)) == null) throw new js__$Boot_HaxeError("nasty");
		this._aReferenceMap.set(this._key_get(oTile),oTileRef);
	}
	,_update: function(oTile) {
		if(this._aReferenceMap.exists(this._key_get(oTile))) return;
		var l = new List();
		l.add(oTile);
		this._referenceMap_update(l);
	}
	,_key_get: function(oTile) {
		return oTile.x_get() + ";" + oTile.y_get();
	}
	,_referenceMap_update: function(lTileStart) {
		var lTileStartRemaining = utils_ListTool.merged_get(lTileStart,new List());
		var oTileParent;
		var oTileChild;
		while(!this._lTileCurrent.isEmpty()) {
			oTileParent = this._lTileCurrent.pop();
			while(lTileStartRemaining.remove(oTileParent)) {
			}
			if(lTileStartRemaining.isEmpty()) return true;
			var _g = 0;
			var _g1 = this._tileChild_get(oTileParent);
			while(_g < _g1.length) {
				var oTileChild1 = _g1[_g];
				++_g;
				if(oTileChild1 != null && js_Boot.__instanceof(oTileChild1,mygame_game_tile_Tile)) {
					if(this._pTest(oTileChild1)) {
						if(this._aReferenceMap.get(this._key_get(oTileChild1)) == null) {
							this._aReferenceMap.set(this._key_get(oTileChild1),oTileParent);
							this._aHeatMap.set(this._key_get(oTileChild1),this._aHeatMap.get(this._key_get(oTileParent)) + 1);
							this._lTileCurrent.add(oTileChild1);
						} else {
							var oPrevRef = this.refTile_get(oTileChild1);
							var oNewRef = oTileParent;
							if(this.heat_get(oNewRef) > this.heat_get(oPrevRef)) continue;
							var oPrevRefRef = this.refTile_get(oPrevRef);
							var oNewRefRef = this.refTile_get(oNewRef);
							var v = this._line_intersect(oNewRef.x_get(),oNewRef.y_get(),oNewRefRef.x_get(),oNewRefRef.y_get(),oPrevRef.x_get(),oPrevRef.y_get(),oPrevRefRef.x_get(),oPrevRefRef.y_get());
							if(v == null) continue;
							var oVectorTmp = new space_Vector3(v.x - oNewRef.x_get(),v.y - oNewRef.y_get());
							if(oVectorTmp.dotProduct(new space_Vector3(oNewRefRef.x_get() - oNewRef.x_get(),oNewRefRef.y_get() - oNewRef.y_get())) < 0) continue;
							var t = this._oWorldMap.tile_get(Math.floor(v.x),Math.floor(v.y));
							if(t == null || !this._pTest(t) || t == oTileChild1) {
								continue;
								throw new js__$Boot_HaxeError("NOT OK");
								throw new js__$Boot_HaxeError("NOT OK");
							}
							this._aReferenceMap.set(this._key_get(oTileChild1),t);
						}
					}
				}
			}
		}
		console.log("[ERROR] : Pathfinder : no PATH found\n");
		return false;
	}
	,_tileChild_get: function(oTileParent) {
		return [this._oWorldMap.tile_get(oTileParent.x_get() + 1,oTileParent.y_get()),this._oWorldMap.tile_get(oTileParent.x_get() - 1,oTileParent.y_get()),this._oWorldMap.tile_get(oTileParent.x_get(),oTileParent.y_get() + 1),this._oWorldMap.tile_get(oTileParent.x_get(),oTileParent.y_get() - 1)].filter(function(oTile) {
			return oTile != null;
		});
	}
	,heat_get: function(oTile) {
		return this._aHeatMap.get(this._key_get(oTile));
	}
	,refMapDiff_get: function(x,y) {
		var v = new space_Vector3();
		v.x = this._aReferenceMap.get(x + ";" + y).x_get() - x;
		v.y = this._aReferenceMap.get(x + ";" + y).y_get() - y;
		return v;
	}
	,_line_intersect: function(x1,y1,x2,y2,x3,y3,x4,y4) {
		var a = x1 * y2 - y1 * x2;
		var dX34 = x3 - x4;
		var dX12 = x1 - x2;
		var d = x3 * y4 - y3 * x4;
		var dy34 = y3 - y4;
		var dy12 = y1 - y2;
		var g = dX12 * dy34 - dy12 * dX34;
		if(g == 0) return null;
		var v = new space_Vector3();
		v.x = (a * dX34 - dX12 * d) / g;
		v.y = (a * dy34 - dy12 * d) / g;
		return v;
	}
	,__class__: mygame_game_utils_PathFinderFlowField
};
var mygame_game_utils_Timer = function(oGame,iFrequency,bLoop) {
	if(bLoop == null) bLoop = false;
	this._oGame = oGame;
	this.set(iFrequency,bLoop);
};
$hxClasses["mygame.game.utils.Timer"] = mygame_game_utils_Timer;
mygame_game_utils_Timer.__name__ = ["mygame","game","utils","Timer"];
mygame_game_utils_Timer.prototype = {
	reset: function() {
		this._iStart = this.timeCurrent_get();
		this._iExpired = this._iStart + this._iFrequency;
	}
	,set: function(iFrequency,bLoop) {
		if(bLoop == null) bLoop = false;
		this._iFrequency = iFrequency;
		this.reset();
	}
	,expired_check: function() {
		return this._iExpired < this.timeCurrent_get();
	}
	,timeCurrent_get: function() {
		return this._oGame.loopId_get();
	}
	,timeRemain_get: function() {
		return this.timeCurrent_get() - this._iExpired;
	}
	,expire_get: function() {
		return this._iExpired;
	}
	,expirePercent_get: function() {
		return (this.timeCurrent_get() - this._iStart) / (this._iExpired - this._iStart);
	}
	,__class__: mygame_game_utils_Timer
};
var websocket_php_Socket = function(oResource) {
	this._oResource = oResource;
	this._bClosed = false;
	this.onClose = new trigger_eventdispatcher_EventDispatcher();
	__call__("socket_set_nonblock",this._oResource);
};
$hxClasses["websocket.php.Socket"] = websocket_php_Socket;
websocket_php_Socket.__name__ = ["websocket","php","Socket"];
websocket_php_Socket.prototype = {
	resource_get: function() {
		return this._oResource;
	}
	,closed_check: function() {
		return this._bClosed;
	}
	,close: function() {
		__call__("socket_close",this._oResource);
		this._close();
	}
	,errorLast_get: function() {
		var iErrorCode = __call__("socket_last_error",this._oResource);
		return __call__("socket_strerror",iErrorCode);
	}
	,_close: function() {
		this._bClosed = true;
		this.onClose.dispatch(this);
	}
	,__class__: websocket_php_Socket
};
var websocket_php_SocketDistant = function(oResource) {
	websocket_php_Socket.call(this,oResource);
	this._bHandshaked = false;
	this._sInBuffer = "";
	this.onMessage = new trigger_eventdispatcher_EventDispatcher();
	this.onClose = new trigger_eventdispatcher_EventDispatcher();
};
$hxClasses["websocket.php.SocketDistant"] = websocket_php_SocketDistant;
websocket_php_SocketDistant.__name__ = ["websocket","php","SocketDistant"];
websocket_php_SocketDistant.__super__ = websocket_php_Socket;
websocket_php_SocketDistant.prototype = $extend(websocket_php_Socket.prototype,{
	isHandshaked_get: function() {
		return this._bHandshaked;
	}
	,process: function() {
		var iLength = 4096;
		if(this.closed_check() == true) return;
		this._sInBuffer = "";
		var iByteN = __call__("@socket_recv",this._oResource,this._sInBuffer,iLength,0);
		if(iByteN == false) {
			var error = __call__("socket_last_error",this._oResource);
			if(error != 0) console.log("[ERROR]:socket error:" + __call__("socket_strerror",error));
			return;
		}
		if(iByteN == 0) return;
		if(this._sInBuffer.length == 0) {
			console.log("[WARNING]:did not close proper way");
			this._close();
			return;
		}
		if(!this.isHandshaked_get()) {
			this._handshake(this._sInBuffer);
			return;
		}
		var oMessage = websocket_crypto_Hybi10.decode(this._sInBuffer);
		this._sInBuffer = oMessage.payload_get();
		if(oMessage.opcode_get() == 8) {
			this._close();
			return;
		}
		this._message_handle();
	}
	,_handshake: function(sHandshake) {
		this.write(websocket_crypto_Hybi10.handshake_get(sHandshake));
		this._bHandshaked = true;
	}
	,_message_handle: function() {
		console.log("[NOTICE]:SocketDistant:message receive : " + this._sInBuffer);
		this.onMessage.dispatch(this);
	}
	,write: function(sBuffer) {
		var sOutBuffer = sBuffer;
		if(this.isHandshaked_get()) sOutBuffer = websocket_crypto_Hybi10.encode(sOutBuffer);
		return __call__("socket_write",this._oResource,sOutBuffer,sOutBuffer.length);
	}
	,readResult_get: function() {
		return this._sInBuffer;
	}
	,handshake: function(sHandshake) {
		this._handshake(sHandshake);
	}
	,__class__: websocket_php_SocketDistant
});
var mygame_server_model_Client = function(oResource) {
	this._iSlotId = -1;
	this._oRoom = null;
	websocket_php_SocketDistant.call(this,oResource);
	this._oMySerializer = new mygame_connection_MySerializer();
	this._oMySerializer.useCache = true;
};
$hxClasses["mygame.server.model.Client"] = mygame_server_model_Client;
mygame_server_model_Client.__name__ = ["mygame","server","model","Client"];
mygame_server_model_Client.__interfaces__ = [trigger_ITrigger];
mygame_server_model_Client.__super__ = websocket_php_SocketDistant;
mygame_server_model_Client.prototype = $extend(websocket_php_SocketDistant.prototype,{
	messageLast_get: function() {
		return this._oMessageLast;
	}
	,slotId_get: function() {
		return this._iSlotId;
	}
	,player_get: function() {
		return this._oRoom.game_get().player_get(this._iSlotId);
	}
	,room_get: function() {
		return this._oRoom;
	}
	,room_set: function(oRoom,iSlotId) {
		this._oRoom = oRoom;
		this._iSlotId = iSlotId;
	}
	,send: function(oMessage) {
		haxe_Serializer.USE_CACHE = true;
		if(js_Boot.__instanceof(oMessage,mygame_connection_message_ReqPlayerInput) || js_Boot.__instanceof(oMessage,mygame_connection_message_ResGameStepInput)) mygame_connection_MySerializer._bUSE_RELATIVE = true; else mygame_connection_MySerializer._bUSE_RELATIVE = false;
		this.write(mygame_connection_MySerializer.run(oMessage));
	}
	,_message_handle: function() {
		this._oMessageLast = mygame_connection_MyUnserializer.run(this.readResult_get(),this.game_get());
		websocket_php_SocketDistant.prototype._message_handle.call(this);
	}
	,trigger: function(oSource) {
	}
	,game_get: function() {
		if(this._oRoom == null) return null;
		return this._oRoom.game_get();
	}
	,__class__: mygame_server_model_Client
});
var mygame_server_model_Room = function(oGame) {
	this._fGamePaceLapse = 45;
	this._sPasswordShadow = "";
	this._bPlayerSpontaneous = true;
	this._iSpectatorMax = 0;
	this._oGame = oGame;
	this._aoSlot = [];
	this._abPause = [];
	this._iSlotQuantityMax = 5;
	var _g1 = 0;
	var _g = this._iSlotQuantityMax;
	while(_g1 < _g) {
		var i = _g1++;
		this._aoSlot[i] = null;
	}
	this._loAction = new List();
	this.onUpdate = new trigger_eventdispatcher_EventDispatcher();
	this._oGame.onLoop.attach(new mygame_game_process_MobilityProcess(this._oGame));
	this.timer_reset();
};
$hxClasses["mygame.server.model.Room"] = mygame_server_model_Room;
mygame_server_model_Room.__name__ = ["mygame","server","model","Room"];
mygame_server_model_Room.prototype = {
	spectatorMax_get: function() {
		return this._iSpectatorMax;
	}
	,spectatorMax_set: function(iSpectatorMax) {
		this._iSpectatorMax = iSpectatorMax;
	}
	,client_get: function(iSlotId) {
		return this._aoSlot[iSlotId];
	}
	,clientList_get: function() {
		var loClient = new List();
		var _g = 0;
		var _g1 = this._aoSlot;
		while(_g < _g1.length) {
			var oClient = _g1[_g];
			++_g;
			if(oClient != null) loClient.push(oClient);
		}
		return loClient;
	}
	,pauseList_get: function() {
		console.log(this._aoSlot);
		console.log(this._abPause);
		return this._abPause;
	}
	,paused_get: function() {
		if(this._abPause.length == 0) return true;
		var _g = 0;
		var _g1 = this._abPause;
		while(_g < _g1.length) {
			var bPlayerReady = _g1[_g];
			++_g;
			if(!bPlayerReady) return true;
		}
		return false;
	}
	,slotIndex_get_byClient: function(oClient) {
		var _g1 = 0;
		var _g = this._aoSlot.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this._aoSlot[i] == oClient) return i;
		}
		return null;
	}
	,game_get: function() {
		return this._oGame;
	}
	,gameActionList_get: function() {
		return this._loAction;
	}
	,gameSpeed_get: function() {
		return this._fGamePaceLapse;
	}
	,timerExpire_check: function() {
		return this._oGamePaceTimer < new Date().getTime();
	}
	,clientReady_update: function(oClient,bReady) {
		var iSlotIndex = this.slotIndex_get_byClient(oClient);
		if(iSlotIndex == null) {
			console.log("invalid client for clientReady_update");
			return null;
		}
		this._abPause[iSlotIndex] = bReady;
		this.onUpdate.dispatch(this);
		return this;
	}
	,slot_occupy: function(oClient,iSlotId) {
		console.log("occupying #" + iSlotId);
		if(!this.slotIdInRange_check(iSlotId)) throw new js__$Boot_HaxeError("slot not in range");
		if(this.slotOccupy_check(iSlotId)) throw new js__$Boot_HaxeError("slot #" + iSlotId + " is unavailable :" + Std.string(this._aoSlot[iSlotId]));
		oClient.room_set(this,iSlotId);
		this._aoSlot[iSlotId] = oClient;
		this._abPause[iSlotId] = false;
		console.log("create");
		console.log(this._abPause);
		return iSlotId;
	}
	,slot_leave: function(oClient) {
		console.log("Client #" + Std.string(oClient.resource_get()) + "leaving slot #" + oClient.slotId_get());
		this._aoSlot[oClient.slotId_get()] = null;
		var i = oClient.slotId_get();
		this._abPause.slice(i,i);
	}
	,slotOccupy_check: function(iSlotId) {
		if(this.client_get(iSlotId) == null) return false;
		return true;
	}
	,slotFreeAny_get: function() {
		var _g1 = 0;
		var _g = this._iSlotQuantityMax;
		while(_g1 < _g) {
			var i = _g1++;
			if(this._aoSlot[i] == null) return i;
		}
		return null;
	}
	,slotFreeList_get: function() {
		throw new js__$Boot_HaxeError("not implemented yet");
	}
	,gameAction_add: function(oAction) {
		this._loAction.push(oAction);
	}
	,process: function() {
		var _g_head = this._loAction.h;
		var _g_val = null;
		while(_g_head != null) {
			var oInput;
			oInput = (function($this) {
				var $r;
				_g_val = _g_head[0];
				_g_head = _g_head[1];
				$r = _g_val;
				return $r;
			}(this));
			this._oGame.action_run(oInput);
		}
		this._oGame.loop();
		this.timer_reset();
		this._loAction = new List();
	}
	,timer_reset: function() {
		this._oGamePaceTimer = new Date().getTime() + this._fGamePaceLapse;
	}
	,slotIdInRange_check: function(iSlotId) {
		if(iSlotId >= 0 && iSlotId < this._iSlotQuantityMax) return true;
		return false;
	}
	,__class__: mygame_server_model_Room
};
var ob3updater_Ob3UpdaterManager = function() {
	this._aOb3Updater = new haxe_ds_IntMap();
};
$hxClasses["ob3updater.Ob3UpdaterManager"] = ob3updater_Ob3UpdaterManager;
ob3updater_Ob3UpdaterManager.__name__ = ["ob3updater","Ob3UpdaterManager"];
ob3updater_Ob3UpdaterManager.prototype = {
	add: function(oOb3Updater) {
		this._aOb3Updater.set(oOb3Updater.object3d_get().id,oOb3Updater);
	}
	,process: function() {
		var $it0 = this._aOb3Updater.iterator();
		while( $it0.hasNext() ) {
			var oOb3Updater = $it0.next();
			oOb3Updater.update();
		}
	}
	,__class__: ob3updater_Ob3UpdaterManager
};
var ob3updater_Transistion = function(oObject3D,iDuration) {
	this._iTimeAlpha = null;
	this._oTimingFunction = ob3updater_Transistion.timeFuncLinear;
	this._oObject3D = oObject3D;
	this._oObject3D.matrixAutoUpdate = false;
	this._oObject3D.updateMatrix();
	this._iDuration = iDuration;
	this._setup(this._oObject3D.matrix);
};
$hxClasses["ob3updater.Transistion"] = ob3updater_Transistion;
ob3updater_Transistion.__name__ = ["ob3updater","Transistion"];
ob3updater_Transistion.__interfaces__ = [ob3updater_IOb3Updater];
ob3updater_Transistion.timeFuncLinear = function(f) {
	return f;
};
ob3updater_Transistion.prototype = {
	object3d_get: function() {
		return this._oObject3D;
	}
	,update: function() {
		var oMatrixOmegaNew = new THREE.Matrix4();
		oMatrixOmegaNew.compose(this._oObject3D.position,this._oObject3D.quaternion,this._oObject3D.scale);
		if(oMatrixOmegaNew.equals(this._oObject3D.matrix)) {
			this._iTimeAlpha = null;
			return;
		}
		if(this._iTimeAlpha == null || !oMatrixOmegaNew.equals(this._oMatrixOmega)) this._setup(oMatrixOmegaNew);
		var oMatrixUpdated = this._oMatrixAlpha.clone();
		var fTimePercent = Math.min(1,this._timeIntervalPercent_get());
		var fMult = this._oTimingFunction(fTimePercent);
		var _g1 = 0;
		var _g = this._oMatrixDelta.elements.length;
		while(_g1 < _g) {
			var i = _g1++;
			oMatrixUpdated.elements[i] = this._oMatrixAlpha.elements[i] + this._oMatrixDelta.elements[i] * fMult;
		}
		this._oObject3D.matrix = oMatrixUpdated;
		this._oObject3D.matrixWorldNeedsUpdate = true;
		if(fTimePercent >= 1) {
			this._iTimeAlpha = null;
			this._oObject3D.matrix = this._oMatrixOmega;
			return;
		}
	}
	,_setup: function(oMatrixOmega) {
		this._oMatrixOmega = oMatrixOmega;
		this._iTimeAlpha = Math.floor(this._timeCurrent_get());
		this._oMatrixAlpha = this._oObject3D.matrix;
		this._oMatrixDelta = this._oMatrixOmega.clone();
		var _g1 = 0;
		var _g = this._oMatrixDelta.elements.length;
		while(_g1 < _g) {
			var i = _g1++;
			this._oMatrixDelta.elements[i] = this._oMatrixDelta.elements[i] - this._oMatrixAlpha.elements[i];
		}
	}
	,_timeCurrent_get: function() {
		return new Date().getTime();
	}
	,_timeIntervalPercent_get: function() {
		return (this._timeCurrent_get() - this._iTimeAlpha) / this._iDuration;
	}
	,__class__: ob3updater_Transistion
};
var space_AlignedAxisBox = function(fHalfWidth,fHalfHeight,oPosition) {
	this._fHalfWidth = fHalfWidth;
	this._fHalfHeight = fHalfHeight;
	if(oPosition == null) this._oPosition = new space_Vector3(); else this._oPosition = oPosition;
};
$hxClasses["space.AlignedAxisBox"] = space_AlignedAxisBox;
space_AlignedAxisBox.__name__ = ["space","AlignedAxisBox"];
space_AlignedAxisBox.__interfaces__ = [space_IAlignedAxisBox];
space_AlignedAxisBox.prototype = {
	center_get: function() {
		return this._oPosition;
	}
	,halfWidth_get: function() {
		return this._fHalfWidth;
	}
	,width_get: function() {
		return this._fHalfWidth * 2;
	}
	,height_get: function() {
		return this._fHalfHeight;
	}
	,halfHeight_get: function() {
		return this._fHalfHeight * 2;
	}
	,top_get: function() {
		return this._oPosition.y + this._fHalfHeight;
	}
	,bottom_get: function() {
		return this._oPosition.y - this._fHalfHeight;
	}
	,right_get: function() {
		return this._oPosition.x + this._fHalfWidth;
	}
	,left_get: function() {
		return this._oPosition.x - this._fHalfWidth;
	}
	,__class__: space_AlignedAxisBox
};
var space_IAlignedAxisBoxi = function() { };
$hxClasses["space.IAlignedAxisBoxi"] = space_IAlignedAxisBoxi;
space_IAlignedAxisBoxi.__name__ = ["space","IAlignedAxisBoxi"];
space_IAlignedAxisBoxi.prototype = {
	__class__: space_IAlignedAxisBoxi
};
var space_AlignedAxisBox2i = function(fHalfWidth,fHalfHeight,oPosition) {
	this._fHalfWidth = fHalfWidth;
	this._fHalfHeight = fHalfHeight;
	if(oPosition == null) this._oPosition = new space_Vector2i(); else this._oPosition = oPosition;
};
$hxClasses["space.AlignedAxisBox2i"] = space_AlignedAxisBox2i;
space_AlignedAxisBox2i.__name__ = ["space","AlignedAxisBox2i"];
space_AlignedAxisBox2i.__interfaces__ = [space_IAlignedAxisBoxi];
space_AlignedAxisBox2i.prototype = {
	center_get: function() {
		return this._oPosition;
	}
	,halfWidth_get: function() {
		return this._fHalfWidth;
	}
	,width_get: function() {
		return this._fHalfWidth * 2;
	}
	,height_get: function() {
		return this._fHalfHeight * 2;
	}
	,halfHeight_get: function() {
		return this._fHalfHeight;
	}
	,top_get: function() {
		return this._oPosition.y + this._fHalfHeight;
	}
	,bottom_get: function() {
		return this._oPosition.y - this._fHalfHeight;
	}
	,right_get: function() {
		return this._oPosition.x + this._fHalfWidth;
	}
	,left_get: function() {
		return this._oPosition.x - this._fHalfWidth;
	}
	,__class__: space_AlignedAxisBox2i
};
var space_AlignedAxisBoxAlti = function(iWidth,iHeight,oBottomLeft) {
	this._iWidth = iWidth;
	this._iHeight = iHeight;
	if(oBottomLeft == null) this._oBottomLeft = new space_Vector2i(); else this._oBottomLeft = oBottomLeft;
};
$hxClasses["space.AlignedAxisBoxAlti"] = space_AlignedAxisBoxAlti;
space_AlignedAxisBoxAlti.__name__ = ["space","AlignedAxisBoxAlti"];
space_AlignedAxisBoxAlti.__interfaces__ = [space_IAlignedAxisBoxi];
space_AlignedAxisBoxAlti.prototype = {
	width_get: function() {
		return this._iWidth;
	}
	,height_get: function() {
		return this._iHeight;
	}
	,haliWidth_get: function() {
		return this._iWidth / 2;
	}
	,haliHeight_get: function() {
		return this._iHeight / 2;
	}
	,top_get: function() {
		return this._oBottomLeft.y + this._iHeight;
	}
	,bottom_get: function() {
		return this._oBottomLeft.y;
	}
	,right_get: function() {
		return this._oBottomLeft.x + this._iWidth;
	}
	,left_get: function() {
		return this._oBottomLeft.x;
	}
	,bottomLeft_set: function(x,y) {
		this._oBottomLeft.set(x,y);
	}
	,__class__: space_AlignedAxisBoxAlti
};
var space_Circle = function(oPosition,fRadius) {
	if(oPosition == null) this._oPosition = new space_Vector3(); else this._oPosition = oPosition;
	this._fRadius = Math.max(fRadius,0);
};
$hxClasses["space.Circle"] = space_Circle;
space_Circle.__name__ = ["space","Circle"];
space_Circle.prototype = {
	radius_get: function() {
		return this._fRadius;
	}
	,position_get: function() {
		return this._oPosition;
	}
	,__class__: space_Circle
};
var trigger_EventDispatcher2 = function() {
	this._aoTrigger = [];
};
$hxClasses["trigger.EventDispatcher2"] = trigger_EventDispatcher2;
trigger_EventDispatcher2.__name__ = ["trigger","EventDispatcher2"];
trigger_EventDispatcher2.__interfaces__ = [trigger_IEventDispatcher];
trigger_EventDispatcher2.prototype = {
	attach: function(oITrigger) {
		if(oITrigger == null) throw new js__$Boot_HaxeError("[ERROR]:trigger is null");
		this._aoTrigger.push(oITrigger);
	}
	,remove: function(oITrigger) {
		HxOverrides.remove(this._aoTrigger,oITrigger);
	}
	,event_get: function() {
		return this._oEventCurrent;
	}
	,dispatch: function(oEvent) {
		this._oEventCurrent = oEvent;
		var _g = 0;
		var _g1 = this._aoTrigger;
		while(_g < _g1.length) {
			var oTrigger = _g1[_g];
			++_g;
			oTrigger.trigger(this);
		}
		return this;
	}
	,source_check: function(oSource) {
		if(oSource == this) return true;
		return false;
	}
	,__class__: trigger_EventDispatcher2
};
var trigger_EventDispatcherTree = function(oParent) {
	trigger_EventDispatcher2.call(this);
	this._oParent = oParent;
};
$hxClasses["trigger.EventDispatcherTree"] = trigger_EventDispatcherTree;
trigger_EventDispatcherTree.__name__ = ["trigger","EventDispatcherTree"];
trigger_EventDispatcherTree.__super__ = trigger_EventDispatcher2;
trigger_EventDispatcherTree.prototype = $extend(trigger_EventDispatcher2.prototype,{
	dispatch: function(oEvent) {
		trigger_EventDispatcher2.prototype.dispatch.call(this,oEvent);
		if(this._oParent != null) this._oParent.dispatch(oEvent);
		return this;
	}
	,source_check: function(oSource) {
		if(oSource == this) return true;
		return this._oParent.source_check(oSource);
	}
	,__class__: trigger_EventDispatcherTree
});
var trigger_eventdispatcher_EventDispatcherJS = function(sType,oEventTarget) {
	trigger_eventdispatcher_EventDispatcher.call(this);
	this._sType = sType;
	if(oEventTarget == null) oEventTarget = window;
	oEventTarget.addEventListener(this._sType,$bind(this,this.dispatch));
};
$hxClasses["trigger.eventdispatcher.EventDispatcherJS"] = trigger_eventdispatcher_EventDispatcherJS;
trigger_eventdispatcher_EventDispatcherJS.__name__ = ["trigger","eventdispatcher","EventDispatcherJS"];
trigger_eventdispatcher_EventDispatcherJS.__super__ = trigger_eventdispatcher_EventDispatcher;
trigger_eventdispatcher_EventDispatcherJS.prototype = $extend(trigger_eventdispatcher_EventDispatcher.prototype,{
	__class__: trigger_eventdispatcher_EventDispatcherJS
});
var trigger_eventdispatcher_EventDispatcherTree = function(oParent) {
	trigger_eventdispatcher_EventDispatcher.call(this);
	this._oParent = oParent;
};
$hxClasses["trigger.eventdispatcher.EventDispatcherTree"] = trigger_eventdispatcher_EventDispatcherTree;
trigger_eventdispatcher_EventDispatcherTree.__name__ = ["trigger","eventdispatcher","EventDispatcherTree"];
trigger_eventdispatcher_EventDispatcherTree.__super__ = trigger_eventdispatcher_EventDispatcher;
trigger_eventdispatcher_EventDispatcherTree.prototype = $extend(trigger_eventdispatcher_EventDispatcher.prototype,{
	dispatch: function(oEvent) {
		trigger_eventdispatcher_EventDispatcher.prototype.dispatch.call(this,oEvent);
		if(this._oParent != null) this._oParent.dispatch(oEvent);
		return this;
	}
	,__class__: trigger_eventdispatcher_EventDispatcherTree
});
var utils_Disposer = function() {
};
$hxClasses["utils.Disposer"] = utils_Disposer;
utils_Disposer.__name__ = ["utils","Disposer"];
utils_Disposer.dispose = function(o) {
	if(o == null) throw new js__$Boot_HaxeError("[ERROR]:Disposer:dispose:o is null.");
	var _g = 0;
	var _g1 = Reflect.fields(o);
	while(_g < _g1.length) {
		var oField = _g1[_g];
		++_g;
		o[oField] = null;
	}
};
utils_Disposer.prototype = {
	__class__: utils_Disposer
};
var utils_ListTool = function() { };
$hxClasses["utils.ListTool"] = utils_ListTool;
utils_ListTool.__name__ = ["utils","ListTool"];
utils_ListTool.merged_get = function(a1,a2) {
	var a = new List();
	var _g_head = a1.h;
	var _g_val = null;
	while(_g_head != null) {
		var oElem;
		oElem = (function($this) {
			var $r;
			_g_val = _g_head[0];
			_g_head = _g_head[1];
			$r = _g_val;
			return $r;
		}(this));
		a.add(oElem);
	}
	var _g_head1 = a2.h;
	var _g_val1 = null;
	while(_g_head1 != null) {
		var oElem1;
		oElem1 = (function($this) {
			var $r;
			_g_val1 = _g_head1[0];
			_g_head1 = _g_head1[1];
			$r = _g_val1;
			return $r;
		}(this));
		a.add(oElem1);
	}
	return a;
};
utils_ListTool.index_get = function(l,o) {
	var i = 0;
	var _g_head = l.h;
	var _g_val = null;
	while(_g_head != null) {
		var x;
		_g_val = _g_head[0];
		_g_head = _g_head[1];
		x = _g_val;
		if(x == o) return i;
		i++;
	}
	return -1;
};
var utils_three_Coordonate = function() { };
$hxClasses["utils.three.Coordonate"] = utils_three_Coordonate;
utils_three_Coordonate.__name__ = ["utils","three","Coordonate"];
utils_three_Coordonate.init = function() {
	if(utils_three_Coordonate._bInit) return;
	utils_three_Coordonate._oPlane = new THREE.Plane(new THREE.Vector3(0,0,1),-0.5);
	utils_three_Coordonate._oProjector = new THREE.Projector();
	utils_three_Coordonate._bInit = true;
};
utils_three_Coordonate.canva_to_eye = function(x,y,oRenderer,oVector) {
	utils_three_Coordonate.init();
	if(oVector == null) oVector = new THREE.Vector3();
	oVector.set(x / oRenderer.domElement.clientWidth * 2 - 1,1 - y / oRenderer.domElement.clientHeight * 2,0.5);
	return oVector;
};
utils_three_Coordonate.screen_to_worldGround = function(x,y,oRenderer,oCamera,oVector) {
	var oPlane = new THREE.Mesh(new THREE.PlaneGeometry(2000000,2000000),new THREE.MeshLambertMaterial());
	oPlane.position.set(0,0,5000);
	utils_three_Coordonate.init();
	if(oVector == null) oVector = new THREE.Vector3();
	utils_three_Coordonate.canva_to_eye(x,y,oRenderer,oVector);
	var oRaycaster = new THREE.Raycaster();
	oRaycaster.setFromCamera(oVector.clone(),oCamera);
	return oRaycaster.ray.intersectPlane(utils_three_Coordonate._oPlane);
};
var utils_time_ITimer = function() { };
$hxClasses["utils.time.ITimer"] = utils_time_ITimer;
utils_time_ITimer.__name__ = ["utils","time","ITimer"];
utils_time_ITimer.prototype = {
	__class__: utils_time_ITimer
};
var utils_time_TimerReal = function(iExpire,bLoop) {
	if(bLoop == null) bLoop = false;
	this._iExpire = iExpire;
	this.reset();
};
$hxClasses["utils.time.TimerReal"] = utils_time_TimerReal;
utils_time_TimerReal.__name__ = ["utils","time","TimerReal"];
utils_time_TimerReal.__interfaces__ = [utils_time_ITimer];
utils_time_TimerReal.prototype = {
	isExpired_get: function() {
		return this.expire_get() < 0;
	}
	,expire_get: function() {
		return this._iStart + this._iExpire - this._timeNow_get();
	}
	,expirePercent_get: function() {
		return this._timeNow_get() / this._iExpire;
	}
	,reset: function() {
		this._iStart = this._timeNow_get();
	}
	,_timeNow_get: function() {
		return Math.floor(new Date().getTime());
	}
	,__class__: utils_time_TimerReal
};
var websocket_MessageComposite = function(aMessage) {
	this._aMessage = aMessage;
};
$hxClasses["websocket.MessageComposite"] = websocket_MessageComposite;
websocket_MessageComposite.__name__ = ["websocket","MessageComposite"];
websocket_MessageComposite.__interfaces__ = [websocket_IMessage];
websocket_MessageComposite.prototype = {
	componentArray_get: function() {
		return this._aMessage;
	}
	,__class__: websocket_MessageComposite
};
var websocket_WSMessage = function(iOpCode,sPayload) {
	this._iOpCode = iOpCode;
	this._sPayload = sPayload;
};
$hxClasses["websocket.WSMessage"] = websocket_WSMessage;
websocket_WSMessage.__name__ = ["websocket","WSMessage"];
websocket_WSMessage.prototype = {
	opcode_get: function() {
		return this._iOpCode;
	}
	,payload_get: function() {
		return this._sPayload;
	}
	,__class__: websocket_WSMessage
};
var websocket_crypto_Hybi10 = function() { };
$hxClasses["websocket.crypto.Hybi10"] = websocket_crypto_Hybi10;
websocket_crypto_Hybi10.__name__ = ["websocket","crypto","Hybi10"];
websocket_crypto_Hybi10.encode = function(sPayload,bMasked) {
	if(bMasked == null) bMasked = false;
	if(bMasked) throw new js__$Boot_HaxeError("Mask not implemented yet.");
	var sType = "text";
	var bContinuous = false;
	var b1 = 0;
	switch(sType) {
	case "continuous":
		b1 = 0;
		break;
	case "text":
		b1 = 1;
		break;
	case "binary":
		b1 = 2;
		break;
	case "close":
		b1 = 8;
		break;
	case "ping":
		b1 = 9;
		break;
	case "pong":
		b1 = 10;
		break;
	default:
		console.log("Uknown opcode");
	}
	if(bContinuous) {
	} else b1 += 128;
	var iLength = sPayload.length;
	var b2 = 0;
	var sLengthField = "";
	if(iLength < 126) b2 = iLength; else if(iLength <= 65536) {
		b2 = 126;
		sLengthField = String.fromCharCode((iLength & 65280) >> 8) + String.fromCharCode(iLength & 255);
	} else {
		console.log("fat load : " + iLength);
		b2 = 127;
		var _g = 0;
		while(_g < 4) {
			var i = _g++;
			sLengthField += String.fromCharCode(0);
		}
		sLengthField += String.fromCharCode((iLength & -16777216) >> 24);
		sLengthField += String.fromCharCode((iLength & 16711680) >> 16);
		sLengthField += String.fromCharCode((iLength & 65280) >> 8);
		sLengthField += String.fromCharCode(iLength & 255);
		console.log("WARNING: untested functionnality");
	}
	return String.fromCharCode(b1) + String.fromCharCode(b2) + sLengthField + sPayload;
};
websocket_crypto_Hybi10.decode = function(sData) {
	var iOpCode = HxOverrides.cca(sData,0) & 15;
	var iPayloadLength = HxOverrides.cca(sData,1) & 127;
	var bMaskEnabled = (HxOverrides.cca(sData,1) & 128) != 0;
	var iPayloadOffset = null;
	var sMask = null;
	if(iPayloadLength == 126) {
		sMask = HxOverrides.substr(sData,4,4);
		iPayloadOffset = 8;
	} else if(iPayloadLength == 127) {
		sMask = HxOverrides.substr(sData,10,4);
		iPayloadOffset = 14;
	} else {
		sMask = HxOverrides.substr(sData,2,4);
		iPayloadOffset = 6;
	}
	var sPayload = null;
	if(bMaskEnabled == true) {
		sPayload = "";
		var _g1 = iPayloadOffset;
		var _g = sData.length;
		while(_g1 < _g) {
			var i = _g1++;
			var j = i - iPayloadOffset;
			sPayload += String.fromCharCode(HxOverrides.cca(sData,i) ^ HxOverrides.cca(sMask,j % 4));
		}
	} else {
		iPayloadOffset -= 4;
		sPayload = HxOverrides.substr(sData,iPayloadOffset,null);
	}
	return new websocket_WSMessage(iOpCode,sPayload);
};
websocket_crypto_Hybi10.handshake_get = function(sClientHandshake) {
	var sWSProtocol = "";
	var oRegExp = new EReg("Sec-WebSocket-Key: (.*)\r\n","");
	oRegExp.match(sClientHandshake);
	var sKey = "";
	sKey = oRegExp.matched(1);
	var sWSAccept = websocket_crypto_Hybi10.accept_get(sKey);
	var sResponse = "";
	sResponse += "HTTP/1.1 101 Switching Protocols\r\n" + "Upgrade: WebSocket\r\n" + "Connection: Upgrade\r\n" + "Sec-WebSocket-Accept: " + sWSAccept + "\r\n";
	if(sWSProtocol != "") sResponse += "Sec-WebSocket-Protocol: TODONameMyApply\r\n";
	sResponse += "\r\n";
	return sResponse;
};
websocket_crypto_Hybi10.accept_get = function(sKey) {
	return __call__("base64_encode",__call__("pack","H*",haxe_crypto_Sha1.encode(sKey + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11")));
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
};
$hxClasses.Math = Math;
String.prototype.__class__ = $hxClasses.String = String;
String.__name__ = ["String"];
$hxClasses.Array = Array;
Array.__name__ = ["Array"];
Date.prototype.__class__ = $hxClasses.Date = Date;
Date.__name__ = ["Date"];
var Int = $hxClasses.Int = { __name__ : ["Int"]};
var Dynamic = $hxClasses.Dynamic = { __name__ : ["Dynamic"]};
var Float = $hxClasses.Float = Number;
Float.__name__ = ["Float"];
var Bool = $hxClasses.Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = $hxClasses.Class = { __name__ : ["Class"]};
var Enum = { };
if(Array.prototype.filter == null) Array.prototype.filter = function(f1) {
	var a1 = [];
	var _g11 = 0;
	var _g2 = this.length;
	while(_g11 < _g2) {
		var i1 = _g11++;
		var e = this[i1];
		if(f1(e)) a1.push(e);
	}
	return a1;
};
var __map_reserved = {}
var ArrayBuffer = $global.ArrayBuffer || js_html_compat_ArrayBuffer;
if(ArrayBuffer.prototype.slice == null) ArrayBuffer.prototype.slice = js_html_compat_ArrayBuffer.sliceImpl;
var DataView = $global.DataView || js_html_compat_DataView;
var Uint8Array = $global.Uint8Array || js_html_compat_Uint8Array._new;
/**
 * @author mrdoob / http://mrdoob.com/
 * @author supereggbert / http://www.paulbrunt.co.uk/
 * @author julianwa / https://github.com/julianwa
 */

THREE.RenderableObject = function () {

	this.id = 0;

	this.object = null;
	this.z = 0;
	this.renderOrder = 0;

};

//

THREE.RenderableFace = function () {

	this.id = 0;

	this.v1 = new THREE.RenderableVertex();
	this.v2 = new THREE.RenderableVertex();
	this.v3 = new THREE.RenderableVertex();

	this.normalModel = new THREE.Vector3();

	this.vertexNormalsModel = [ new THREE.Vector3(), new THREE.Vector3(), new THREE.Vector3() ];
	this.vertexNormalsLength = 0;

	this.color = new THREE.Color();
	this.material = null;
	this.uvs = [ new THREE.Vector2(), new THREE.Vector2(), new THREE.Vector2() ];

	this.z = 0;
	this.renderOrder = 0;

};

//

THREE.RenderableVertex = function () {

	this.position = new THREE.Vector3();
	this.positionWorld = new THREE.Vector3();
	this.positionScreen = new THREE.Vector4();

	this.visible = true;

};

THREE.RenderableVertex.prototype.copy = function ( vertex ) {

	this.positionWorld.copy( vertex.positionWorld );
	this.positionScreen.copy( vertex.positionScreen );

};

//

THREE.RenderableLine = function () {

	this.id = 0;

	this.v1 = new THREE.RenderableVertex();
	this.v2 = new THREE.RenderableVertex();

	this.vertexColors = [ new THREE.Color(), new THREE.Color() ];
	this.material = null;

	this.z = 0;
	this.renderOrder = 0;

};

//

THREE.RenderableSprite = function () {

	this.id = 0;

	this.object = null;

	this.x = 0;
	this.y = 0;
	this.z = 0;

	this.rotation = 0;
	this.scale = new THREE.Vector2();

	this.material = null;
	this.renderOrder = 0;

};

//

THREE.Projector = function () {

	var _object, _objectCount, _objectPool = [], _objectPoolLength = 0,
	_vertex, _vertexCount, _vertexPool = [], _vertexPoolLength = 0,
	_face, _faceCount, _facePool = [], _facePoolLength = 0,
	_line, _lineCount, _linePool = [], _linePoolLength = 0,
	_sprite, _spriteCount, _spritePool = [], _spritePoolLength = 0,

	_renderData = { objects: [], lights: [], elements: [] },

	_vector3 = new THREE.Vector3(),
	_vector4 = new THREE.Vector4(),

	_clipBox = new THREE.Box3( new THREE.Vector3( - 1, - 1, - 1 ), new THREE.Vector3( 1, 1, 1 ) ),
	_boundingBox = new THREE.Box3(),
	_points3 = new Array( 3 ),
	_points4 = new Array( 4 ),

	_viewMatrix = new THREE.Matrix4(),
	_viewProjectionMatrix = new THREE.Matrix4(),

	_modelMatrix,
	_modelViewProjectionMatrix = new THREE.Matrix4(),

	_normalMatrix = new THREE.Matrix3(),

	_frustum = new THREE.Frustum(),

	_clippedVertex1PositionScreen = new THREE.Vector4(),
	_clippedVertex2PositionScreen = new THREE.Vector4();

	//

	this.projectVector = function ( vector, camera ) {

		console.warn( 'THREE.Projector: .projectVector() is now vector.project().' );
		vector.project( camera );

	};

	this.unprojectVector = function ( vector, camera ) {

		console.warn( 'THREE.Projector: .unprojectVector() is now vector.unproject().' );
		vector.unproject( camera );

	};

	this.pickingRay = function ( vector, camera ) {

		console.error( 'THREE.Projector: .pickingRay() is now raycaster.setFromCamera().' );

	};

	//

	var RenderList = function () {

		var normals = [];
		var uvs = [];

		var object = null;
		var material = null;

		var normalMatrix = new THREE.Matrix3();

		var setObject = function ( value ) {

			object = value;
			material = object.material;

			normalMatrix.getNormalMatrix( object.matrixWorld );

			normals.length = 0;
			uvs.length = 0;

		};

		var projectVertex = function ( vertex ) {

			var position = vertex.position;
			var positionWorld = vertex.positionWorld;
			var positionScreen = vertex.positionScreen;

			positionWorld.copy( position ).applyMatrix4( _modelMatrix );
			positionScreen.copy( positionWorld ).applyMatrix4( _viewProjectionMatrix );

			var invW = 1 / positionScreen.w;

			positionScreen.x *= invW;
			positionScreen.y *= invW;
			positionScreen.z *= invW;

			vertex.visible = positionScreen.x >= - 1 && positionScreen.x <= 1 &&
					 positionScreen.y >= - 1 && positionScreen.y <= 1 &&
					 positionScreen.z >= - 1 && positionScreen.z <= 1;

		};

		var pushVertex = function ( x, y, z ) {

			_vertex = getNextVertexInPool();
			_vertex.position.set( x, y, z );

			projectVertex( _vertex );

		};

		var pushNormal = function ( x, y, z ) {

			normals.push( x, y, z );

		};

		var pushUv = function ( x, y ) {

			uvs.push( x, y );

		};

		var checkTriangleVisibility = function ( v1, v2, v3 ) {

			if ( v1.visible === true || v2.visible === true || v3.visible === true ) return true;

			_points3[ 0 ] = v1.positionScreen;
			_points3[ 1 ] = v2.positionScreen;
			_points3[ 2 ] = v3.positionScreen;

			return _clipBox.isIntersectionBox( _boundingBox.setFromPoints( _points3 ) );

		};

		var checkBackfaceCulling = function ( v1, v2, v3 ) {

			return ( ( v3.positionScreen.x - v1.positionScreen.x ) *
				    ( v2.positionScreen.y - v1.positionScreen.y ) -
				    ( v3.positionScreen.y - v1.positionScreen.y ) *
				    ( v2.positionScreen.x - v1.positionScreen.x ) ) < 0;

		};

		var pushLine = function ( a, b ) {

			var v1 = _vertexPool[ a ];
			var v2 = _vertexPool[ b ];

			_line = getNextLineInPool();

			_line.id = object.id;
			_line.v1.copy( v1 );
			_line.v2.copy( v2 );
			_line.z = ( v1.positionScreen.z + v2.positionScreen.z ) / 2;
			_line.renderOrder = object.renderOrder;

			_line.material = object.material;

			_renderData.elements.push( _line );

		};

		var pushTriangle = function ( a, b, c ) {

			var v1 = _vertexPool[ a ];
			var v2 = _vertexPool[ b ];
			var v3 = _vertexPool[ c ];

			if ( checkTriangleVisibility( v1, v2, v3 ) === false ) return;

			if ( material.side === THREE.DoubleSide || checkBackfaceCulling( v1, v2, v3 ) === true ) {

				_face = getNextFaceInPool();

				_face.id = object.id;
				_face.v1.copy( v1 );
				_face.v2.copy( v2 );
				_face.v3.copy( v3 );
				_face.z = ( v1.positionScreen.z + v2.positionScreen.z + v3.positionScreen.z ) / 3;
				_face.renderOrder = object.renderOrder;

				// use first vertex normal as face normal

				_face.normalModel.fromArray( normals, a * 3 );
				_face.normalModel.applyMatrix3( normalMatrix ).normalize();

				for ( var i = 0; i < 3; i ++ ) {

					var normal = _face.vertexNormalsModel[ i ];
					normal.fromArray( normals, arguments[ i ] * 3 );
					normal.applyMatrix3( normalMatrix ).normalize();

					var uv = _face.uvs[ i ];
					uv.fromArray( uvs, arguments[ i ] * 2 );

				}

				_face.vertexNormalsLength = 3;

				_face.material = object.material;

				_renderData.elements.push( _face );

			}

		};

		return {
			setObject: setObject,
			projectVertex: projectVertex,
			checkTriangleVisibility: checkTriangleVisibility,
			checkBackfaceCulling: checkBackfaceCulling,
			pushVertex: pushVertex,
			pushNormal: pushNormal,
			pushUv: pushUv,
			pushLine: pushLine,
			pushTriangle: pushTriangle
		}

	};

	var renderList = new RenderList();

	this.projectScene = function ( scene, camera, sortObjects, sortElements ) {

		_faceCount = 0;
		_lineCount = 0;
		_spriteCount = 0;

		_renderData.elements.length = 0;

		if ( scene.autoUpdate === true ) scene.updateMatrixWorld();
		if ( camera.parent === null ) camera.updateMatrixWorld();

		_viewMatrix.copy( camera.matrixWorldInverse.getInverse( camera.matrixWorld ) );
		_viewProjectionMatrix.multiplyMatrices( camera.projectionMatrix, _viewMatrix );

		_frustum.setFromMatrix( _viewProjectionMatrix );

		//

		_objectCount = 0;

		_renderData.objects.length = 0;
		_renderData.lights.length = 0;

		scene.traverseVisible( function ( object ) {

			if ( object instanceof THREE.Light ) {

				_renderData.lights.push( object );

			} else if ( object instanceof THREE.Mesh || object instanceof THREE.Line || object instanceof THREE.Sprite ) {

				var material = object.material;

				if ( material.visible === false ) return;

				if ( object.frustumCulled === false || _frustum.intersectsObject( object ) === true ) {

					_object = getNextObjectInPool();
					_object.id = object.id;
					_object.object = object;

					_vector3.setFromMatrixPosition( object.matrixWorld );
					_vector3.applyProjection( _viewProjectionMatrix );
					_object.z = _vector3.z;
					_object.renderOrder = object.renderOrder;

					_renderData.objects.push( _object );

				}

			}

		} );

		if ( sortObjects === true ) {

			_renderData.objects.sort( painterSort );

		}

		//

		for ( var o = 0, ol = _renderData.objects.length; o < ol; o ++ ) {

			var object = _renderData.objects[ o ].object;
			var geometry = object.geometry;

			renderList.setObject( object );

			_modelMatrix = object.matrixWorld;

			_vertexCount = 0;

			if ( object instanceof THREE.Mesh ) {

				if ( geometry instanceof THREE.BufferGeometry ) {

					var attributes = geometry.attributes;
					var groups = geometry.groups;

					if ( attributes.position === undefined ) continue;

					var positions = attributes.position.array;

					for ( var i = 0, l = positions.length; i < l; i += 3 ) {

						renderList.pushVertex( positions[ i ], positions[ i + 1 ], positions[ i + 2 ] );

					}

					if ( attributes.normal !== undefined ) {

						var normals = attributes.normal.array;

						for ( var i = 0, l = normals.length; i < l; i += 3 ) {

							renderList.pushNormal( normals[ i ], normals[ i + 1 ], normals[ i + 2 ] );

						}

					}

					if ( attributes.uv !== undefined ) {

						var uvs = attributes.uv.array;

						for ( var i = 0, l = uvs.length; i < l; i += 2 ) {

							renderList.pushUv( uvs[ i ], uvs[ i + 1 ] );

						}

					}

					if ( geometry.index !== null ) {

						var indices = geometry.index.array;

						if ( groups.length > 0 ) {

							for ( var o = 0; o < groups.length; o ++ ) {

								var group = groups[ o ];

								for ( var i = group.start, l = group.start + group.count; i < l; i += 3 ) {

									renderList.pushTriangle( indices[ i ], indices[ i + 1 ], indices[ i + 2 ] );

								}

							}

						} else {

							for ( var i = 0, l = indices.length; i < l; i += 3 ) {

								renderList.pushTriangle( indices[ i ], indices[ i + 1 ], indices[ i + 2 ] );

							}

						}

					} else {

						for ( var i = 0, l = positions.length / 3; i < l; i += 3 ) {

							renderList.pushTriangle( i, i + 1, i + 2 );

						}

					}

				} else if ( geometry instanceof THREE.Geometry ) {

					var vertices = geometry.vertices;
					var faces = geometry.faces;
					var faceVertexUvs = geometry.faceVertexUvs[ 0 ];

					_normalMatrix.getNormalMatrix( _modelMatrix );

					var material = object.material;

					var isFaceMaterial = material instanceof THREE.MeshFaceMaterial;
					var objectMaterials = isFaceMaterial === true ? object.material : null;

					for ( var v = 0, vl = vertices.length; v < vl; v ++ ) {

						var vertex = vertices[ v ];

						_vector3.copy( vertex );

						if ( material.morphTargets === true ) {

							var morphTargets = geometry.morphTargets;
							var morphInfluences = object.morphTargetInfluences;

							for ( var t = 0, tl = morphTargets.length; t < tl; t ++ ) {

								var influence = morphInfluences[ t ];

								if ( influence === 0 ) continue;

								var target = morphTargets[ t ];
								var targetVertex = target.vertices[ v ];

								_vector3.x += ( targetVertex.x - vertex.x ) * influence;
								_vector3.y += ( targetVertex.y - vertex.y ) * influence;
								_vector3.z += ( targetVertex.z - vertex.z ) * influence;

							}

						}

						renderList.pushVertex( _vector3.x, _vector3.y, _vector3.z );

					}

					for ( var f = 0, fl = faces.length; f < fl; f ++ ) {

						var face = faces[ f ];

						material = isFaceMaterial === true
							 ? objectMaterials.materials[ face.materialIndex ]
							 : object.material;

						if ( material === undefined ) continue;

						var side = material.side;

						var v1 = _vertexPool[ face.a ];
						var v2 = _vertexPool[ face.b ];
						var v3 = _vertexPool[ face.c ];

						if ( renderList.checkTriangleVisibility( v1, v2, v3 ) === false ) continue;

						var visible = renderList.checkBackfaceCulling( v1, v2, v3 );

						if ( side !== THREE.DoubleSide ) {

							if ( side === THREE.FrontSide && visible === false ) continue;
							if ( side === THREE.BackSide && visible === true ) continue;

						}

						_face = getNextFaceInPool();

						_face.id = object.id;
						_face.v1.copy( v1 );
						_face.v2.copy( v2 );
						_face.v3.copy( v3 );

						_face.normalModel.copy( face.normal );

						if ( visible === false && ( side === THREE.BackSide || side === THREE.DoubleSide ) ) {

							_face.normalModel.negate();

						}

						_face.normalModel.applyMatrix3( _normalMatrix ).normalize();

						var faceVertexNormals = face.vertexNormals;

						for ( var n = 0, nl = Math.min( faceVertexNormals.length, 3 ); n < nl; n ++ ) {

							var normalModel = _face.vertexNormalsModel[ n ];
							normalModel.copy( faceVertexNormals[ n ] );

							if ( visible === false && ( side === THREE.BackSide || side === THREE.DoubleSide ) ) {

								normalModel.negate();

							}

							normalModel.applyMatrix3( _normalMatrix ).normalize();

						}

						_face.vertexNormalsLength = faceVertexNormals.length;

						var vertexUvs = faceVertexUvs[ f ];

						if ( vertexUvs !== undefined ) {

							for ( var u = 0; u < 3; u ++ ) {

								_face.uvs[ u ].copy( vertexUvs[ u ] );

							}

						}

						_face.color = face.color;
						_face.material = material;

						_face.z = ( v1.positionScreen.z + v2.positionScreen.z + v3.positionScreen.z ) / 3;
						_face.renderOrder = object.renderOrder;

						_renderData.elements.push( _face );

					}

				}

			} else if ( object instanceof THREE.Line ) {

				if ( geometry instanceof THREE.BufferGeometry ) {

					var attributes = geometry.attributes;

					if ( attributes.position !== undefined ) {

						var positions = attributes.position.array;

						for ( var i = 0, l = positions.length; i < l; i += 3 ) {

							renderList.pushVertex( positions[ i ], positions[ i + 1 ], positions[ i + 2 ] );

						}

						if ( geometry.index !== null ) {

							var indices = geometry.index.array;

							for ( var i = 0, l = indices.length; i < l; i += 2 ) {

								renderList.pushLine( indices[ i ], indices[ i + 1 ] );

							}

						} else {

							var step = object instanceof THREE.LineSegments ? 2 : 1;

							for ( var i = 0, l = ( positions.length / 3 ) - 1; i < l; i += step ) {

								renderList.pushLine( i, i + 1 );

							}

						}

					}

				} else if ( geometry instanceof THREE.Geometry ) {

					_modelViewProjectionMatrix.multiplyMatrices( _viewProjectionMatrix, _modelMatrix );

					var vertices = object.geometry.vertices;

					if ( vertices.length === 0 ) continue;

					v1 = getNextVertexInPool();
					v1.positionScreen.copy( vertices[ 0 ] ).applyMatrix4( _modelViewProjectionMatrix );

					var step = object instanceof THREE.LineSegments ? 2 : 1;

					for ( var v = 1, vl = vertices.length; v < vl; v ++ ) {

						v1 = getNextVertexInPool();
						v1.positionScreen.copy( vertices[ v ] ).applyMatrix4( _modelViewProjectionMatrix );

						if ( ( v + 1 ) % step > 0 ) continue;

						v2 = _vertexPool[ _vertexCount - 2 ];

						_clippedVertex1PositionScreen.copy( v1.positionScreen );
						_clippedVertex2PositionScreen.copy( v2.positionScreen );

						if ( clipLine( _clippedVertex1PositionScreen, _clippedVertex2PositionScreen ) === true ) {

							// Perform the perspective divide
							_clippedVertex1PositionScreen.multiplyScalar( 1 / _clippedVertex1PositionScreen.w );
							_clippedVertex2PositionScreen.multiplyScalar( 1 / _clippedVertex2PositionScreen.w );

							_line = getNextLineInPool();

							_line.id = object.id;
							_line.v1.positionScreen.copy( _clippedVertex1PositionScreen );
							_line.v2.positionScreen.copy( _clippedVertex2PositionScreen );

							_line.z = Math.max( _clippedVertex1PositionScreen.z, _clippedVertex2PositionScreen.z );
							_line.renderOrder = object.renderOrder;

							_line.material = object.material;

							if ( object.material.vertexColors === THREE.VertexColors ) {

								_line.vertexColors[ 0 ].copy( object.geometry.colors[ v ] );
								_line.vertexColors[ 1 ].copy( object.geometry.colors[ v - 1 ] );

							}

							_renderData.elements.push( _line );

						}

					}

				}

			} else if ( object instanceof THREE.Sprite ) {

				_vector4.set( _modelMatrix.elements[ 12 ], _modelMatrix.elements[ 13 ], _modelMatrix.elements[ 14 ], 1 );
				_vector4.applyMatrix4( _viewProjectionMatrix );

				var invW = 1 / _vector4.w;

				_vector4.z *= invW;

				if ( _vector4.z >= - 1 && _vector4.z <= 1 ) {

					_sprite = getNextSpriteInPool();
					_sprite.id = object.id;
					_sprite.x = _vector4.x * invW;
					_sprite.y = _vector4.y * invW;
					_sprite.z = _vector4.z;
					_sprite.renderOrder = object.renderOrder;
					_sprite.object = object;

					_sprite.rotation = object.rotation;

					_sprite.scale.x = object.scale.x * Math.abs( _sprite.x - ( _vector4.x + camera.projectionMatrix.elements[ 0 ] ) / ( _vector4.w + camera.projectionMatrix.elements[ 12 ] ) );
					_sprite.scale.y = object.scale.y * Math.abs( _sprite.y - ( _vector4.y + camera.projectionMatrix.elements[ 5 ] ) / ( _vector4.w + camera.projectionMatrix.elements[ 13 ] ) );

					_sprite.material = object.material;

					_renderData.elements.push( _sprite );

				}

			}

		}

		if ( sortElements === true ) {

			_renderData.elements.sort( painterSort );

		}

		return _renderData;

	};

	// Pools

	function getNextObjectInPool() {

		if ( _objectCount === _objectPoolLength ) {

			var object = new THREE.RenderableObject();
			_objectPool.push( object );
			_objectPoolLength ++;
			_objectCount ++;
			return object;

		}

		return _objectPool[ _objectCount ++ ];

	}

	function getNextVertexInPool() {

		if ( _vertexCount === _vertexPoolLength ) {

			var vertex = new THREE.RenderableVertex();
			_vertexPool.push( vertex );
			_vertexPoolLength ++;
			_vertexCount ++;
			return vertex;

		}

		return _vertexPool[ _vertexCount ++ ];

	}

	function getNextFaceInPool() {

		if ( _faceCount === _facePoolLength ) {

			var face = new THREE.RenderableFace();
			_facePool.push( face );
			_facePoolLength ++;
			_faceCount ++;
			return face;

		}

		return _facePool[ _faceCount ++ ];


	}

	function getNextLineInPool() {

		if ( _lineCount === _linePoolLength ) {

			var line = new THREE.RenderableLine();
			_linePool.push( line );
			_linePoolLength ++;
			_lineCount ++;
			return line;

		}

		return _linePool[ _lineCount ++ ];

	}

	function getNextSpriteInPool() {

		if ( _spriteCount === _spritePoolLength ) {

			var sprite = new THREE.RenderableSprite();
			_spritePool.push( sprite );
			_spritePoolLength ++;
			_spriteCount ++;
			return sprite;

		}

		return _spritePool[ _spriteCount ++ ];

	}

	//

	function painterSort( a, b ) {

		if ( a.renderOrder !== b.renderOrder ) {

			return a.renderOrder - b.renderOrder;

		} else if ( a.z !== b.z ) {

			return b.z - a.z;

		} else if ( a.id !== b.id ) {

			return a.id - b.id;

		} else {

			return 0;

		}

	}

	function clipLine( s1, s2 ) {

		var alpha1 = 0, alpha2 = 1,

		// Calculate the boundary coordinate of each vertex for the near and far clip planes,
		// Z = -1 and Z = +1, respectively.
		bc1near =  s1.z + s1.w,
		bc2near =  s2.z + s2.w,
		bc1far =  - s1.z + s1.w,
		bc2far =  - s2.z + s2.w;

		if ( bc1near >= 0 && bc2near >= 0 && bc1far >= 0 && bc2far >= 0 ) {

			// Both vertices lie entirely within all clip planes.
			return true;

		} else if ( ( bc1near < 0 && bc2near < 0 ) || ( bc1far < 0 && bc2far < 0 ) ) {

			// Both vertices lie entirely outside one of the clip planes.
			return false;

		} else {

			// The line segment spans at least one clip plane.

			if ( bc1near < 0 ) {

				// v1 lies outside the near plane, v2 inside
				alpha1 = Math.max( alpha1, bc1near / ( bc1near - bc2near ) );

			} else if ( bc2near < 0 ) {

				// v2 lies outside the near plane, v1 inside
				alpha2 = Math.min( alpha2, bc1near / ( bc1near - bc2near ) );

			}

			if ( bc1far < 0 ) {

				// v1 lies outside the far plane, v2 inside
				alpha1 = Math.max( alpha1, bc1far / ( bc1far - bc2far ) );

			} else if ( bc2far < 0 ) {

				// v2 lies outside the far plane, v2 inside
				alpha2 = Math.min( alpha2, bc1far / ( bc1far - bc2far ) );

			}

			if ( alpha2 < alpha1 ) {

				// The line segment spans two boundaries, but is outside both of them.
				// (This can't happen when we're only clipping against just near/far but good
				//  to leave the check here for future usage if other clip planes are added.)
				return false;

			} else {

				// Update the s1 and s2 vertices to match the clipped line segment.
				s1.lerp( s2, alpha1 );
				s2.lerp( s1, 1 - alpha2 );

				return true;

			}

		}

	}

};
;
collider_CollisionCheckerPriorInt._bOb = false;
haxe_Serializer.USE_CACHE = false;
haxe_Serializer.USE_ENUM_INDEX = false;
haxe_Serializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
haxe_Unserializer.DEFAULT_RESOLVER = Type;
haxe_Unserializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
haxe_ds_ObjectMap.count = 0;
haxe_io_FPHelper.i64tmp = (function($this) {
	var $r;
	var x = new haxe__$Int64__$_$_$Int64(0,0);
	$r = x;
	return $r;
}(this));
js_Boot.__toStr = {}.toString;
js_html_compat_Uint8Array.BYTES_PER_ELEMENT = 1;
legion_Game.onAnyStart = new trigger_eventdispatcher_EventDispatcher();
legion_device_Device.onUpdate = new trigger_eventdispatcher_EventDispatcher();
math_Limit.fSmallest = 2.22507385850720e-308;
math_Limit.fLargest = 1.79769313486232e+308;
mygame_client_controller_game_StrategicZoom._fMin = 0;
mygame_client_controller_game_StrategicZoom._fMax = 50;
mygame_client_controller_game_StrategicZoom._fStepQuant = 10;
mygame_client_view_GameView.WORLDMAP_MESHSIZE = 10;
mygame_client_view_visual_EntityVisual._moEntityVisual = mygame_client_view_visual_EntityVisual._moEntityVisual = new haxe_ds_IntMap();
mygame_client_view_visual_MapVisual.LANDHEIGHT = 0.25;
mygame_client_view_visual_ability_GuidanceVisual._oMaterial = new THREE.LineBasicMaterial({ color : 255});
mygame_client_view_visual_ability_WeaponVisual._oMatBackground = new THREE.SpriteMaterial({ color : 0, depthTest : false, depthWrite : false});
mygame_client_view_visual_ability_WeaponVisual._oMatForeground = new THREE.SpriteMaterial({ color : 16733525, depthTest : false, depthWrite : false});
mygame_client_view_visual_ability_WeaponVisual._oMaterial = new THREE.LineBasicMaterial({ color : 16711680});
mygame_client_view_visual_ability_WeaponVisual._fBorderSize = 3;
mygame_client_view_visual_gui_HealthGauge._oMaterialBackground = new THREE.MeshBasicMaterial({ color : 0, depthTest : false, depthWrite : false});
mygame_client_view_visual_gui_HealthGauge._oMaterialGauge = new THREE.MeshBasicMaterial({ color : 1179460, depthTest : false, depthWrite : false});
mygame_client_view_visual_gui_HealthGauge._oGeometryBackground = new THREE.PlaneGeometry(2,2);
mygame_client_view_visual_gui_HealthGauge._oGeometryGauge = new THREE.PlaneGeometry(2,2);
mygame_client_view_visual_unit_CopterVisual._oMaterial = new THREE.LineDashedMaterial({ color : 14606046, dashSize : 3, gapSize : 1});
mygame_connection_MySerializer._bUSE_RELATIVE = false;
mygame_game_ability_BuilderFactory._aOffer = [new mygame_game_misc_offer_Offer(15,"Build a Solier 2"),new mygame_game_misc_offer_Offer(15,"Build a Tank")];
utils_IntTool.MAX = 1073741823;
mygame_game_ability_LoyaltyShift._fStep = 0.01;
mygame_game_ability_LoyaltyShift._oArea = new space_Circlei(new space_Vector2i(),10000);
mygame_game_ability_LoyaltyShift.RANGE = 10000;
mygame_game_entity_WorldMap.TILETYPE_SEA = 0;
mygame_game_entity_WorldMap.TILETYPE_GRASS = 1;
mygame_game_entity_WorldMap.TILETYPE_FOREST = 2;
mygame_game_entity_WorldMap.TILETYPE_MOUNTAIN = 3;
mygame_game_entity_WorldMap.TILETYPE_ROAD = 4;
mygame_game_tile_Tile._oHitBox = new space_AlignedAxisBoxAlt(1,1);
trigger_eventdispatcher_EventDispatcherJS.onClick = new trigger_eventdispatcher_EventDispatcherJS("click");
trigger_eventdispatcher_EventDispatcherJS.onMouseUp = new trigger_eventdispatcher_EventDispatcherJS("mouseup");
trigger_eventdispatcher_EventDispatcherJS.onMouseDown = new trigger_eventdispatcher_EventDispatcherJS("mousedown");
trigger_eventdispatcher_EventDispatcherJS.onMouseMove = new trigger_eventdispatcher_EventDispatcherJS("mousemove");
trigger_eventdispatcher_EventDispatcherJS.onContextMenu = new trigger_eventdispatcher_EventDispatcherJS("contextmenu");
utils_three_Coordonate._bInit = false;
mygame_client_MyClient.main();
})(typeof console != "undefined" ? console : {log:function(){}}, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);
