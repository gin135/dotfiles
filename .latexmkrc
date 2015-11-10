#!/usr/bin/env perl

$latex      = 'platex %O %S -synctex=1';
$dvipdf     = 'dvipdfmx %O %S';
$bibtex     = 'pbibtex %O %B';
$max_repeat = 5;
$pdf_mode   = 3;
