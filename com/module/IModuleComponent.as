package com.module
{
	public interface IModuleComponent
	{
		
		function load( view:String, viewState:String='' ):void;
		function selectView( view:String, viewState:String='' ):void;
		
	}
}