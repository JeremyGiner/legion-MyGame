package legion;

import legion.Game;

interface IQuery<CGame:Game,CPARAM,CDATA> {
	public function data_get( oParameter :CPARAM ) :CDATA;
}