" unimpaired.vim - Pairs of handy bracket mappings
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      2.1
" GetLatestVimScripts: 1590 1 :AutoInstall: unimpaired.vim

if exists("g:loaded_unimpaired") || &cp || v:version < 700
  finish
endif
let g:loaded_unimpaired = 1

function! s:Map(...) abort
  let [mode, head, rhs; rest] = a:000
  let flags = get(rest, 0, '') . (rhs =~# '^<Plug>' ? '' : '<script>')
  let tail = ''
  let keys = get(g:, mode.'remap', {})
  if type(keys) == type({}) && !empty(keys)
    while !empty(head) && len(keys)
      if has_key(keys, head)
        let head = keys[head]
        if empty(head)
          let head = '<skip>'
        endif
        break
      endif
      let tail = matchstr(head, '<[^<>]*>$\|.$') . tail
      let head = substitute(head, '<[^<>]*>$\|.$', '', '')
    endwhile
  endif
  if head !=# '<skip>' && empty(maparg(head.tail, mode))
    return mode.'map ' . flags . ' ' . head.tail . ' ' . rhs
  endif
  return ''
endfunction

" Section: Encoding and decoding

function! s:string_encode(str) abort
  let map = {"\n": 'n', "\r": 'r', "\t": 't', "\b": 'b', "\f": '\f', '"': '"', '\': '\'}
  return substitute(a:str,"[\001-\033\\\\\"]",'\="\\".get(map,submatch(0),printf("%03o",char2nr(submatch(0))))','g')
endfunction

function! s:string_decode(str) abort
  let map = {'n': "\n", 'r': "\r", 't': "\t", 'b': "\b", 'f': "\f", 'e': "\e", 'a': "\001", 'v': "\013", "\n": ''}
  let str = a:str
  if str =~# '^\s*".\{-\}\\\@<!\%(\\\\\)*"\s*\n\=$'
    let str = substitute(substitute(str,'^\s*\zs"','',''),'"\ze\s*\n\=$','','')
  endif
  return substitute(str,'\\\(\o\{1,3\}\|x\x\{1,2\}\|u\x\{1,4\}\|.\)','\=get(map,submatch(1),submatch(1) =~? "^[0-9xu]" ? nr2char("0".substitute(submatch(1),"^[Uu]","x","")) : submatch(1))','g')
endfunction

function! s:url_encode(str) abort
  " iconv trick to convert utf-8 bytes to 8bits indiviual char.
  return substitute(iconv(a:str, 'latin1', 'utf-8'),'[^A-Za-z0-9_.~-]','\="%".printf("%02X",char2nr(submatch(0)))','g')
endfunction

function! s:url_decode(str) abort
  let str = substitute(substitute(substitute(a:str,'%0[Aa]\n$','%0A',''),'%0[Aa]','\n','g'),'+',' ','g')
  return iconv(substitute(str,'%\(\x\x\)','\=nr2char("0x".submatch(1))','g'), 'utf-8', 'latin1')
endfunction

" HTML entities {{{2

let g:unimpaired_html_entities = {
      \ 'nbsp':     160, 'iexcl':    161, 'cent':     162, 'pound':    163,
      \ 'curren':   164, 'yen':      165, 'brvbar':   166, 'sect':     167,
      \ 'uml':      168, 'copy':     169, 'ordf':     170, 'laquo':    171,
      \ 'not':      172, 'shy':      173, 'reg':      174, 'macr':     175,
      \ 'deg':      176, 'plusmn':   177, 'sup2':     178, 'sup3':     179,
      \ 'acute':    180, 'micro':    181, 'para':     182, 'middot':   183,
      \ 'cedil':    184, 'sup1':     185, 'ordm':     186, 'raquo':    187,
      \ 'frac14':   188, 'frac12':   189, 'frac34':   190, 'iquest':   191,
      \ 'Agrave':   192, 'Aacute':   193, 'Acirc':    194, 'Atilde':   195,
      \ 'Auml':     196, 'Aring':    197, 'AElig':    198, 'Ccedil':   199,
      \ 'Egrave':   200, 'Eacute':   201, 'Ecirc':    202, 'Euml':     203,
      \ 'Igrave':   204, 'Iacute':   205, 'Icirc':    206, 'Iuml':     207,
      \ 'ETH':      208, 'Ntilde':   209, 'Ograve':   210, 'Oacute':   211,
      \ 'Ocirc':    212, 'Otilde':   213, 'Ouml':     214, 'times':    215,
      \ 'Oslash':   216, 'Ugrave':   217, 'Uacute':   218, 'Ucirc':    219,
      \ 'Uuml':     220, 'Yacute':   221, 'THORN':    222, 'szlig':    223,
      \ 'agrave':   224, 'aacute':   225, 'acirc':    226, 'atilde':   227,
      \ 'auml':     228, 'aring':    229, 'aelig':    230, 'ccedil':   231,
      \ 'egrave':   232, 'eacute':   233, 'ecirc':    234, 'euml':     235,
      \ 'igrave':   236, 'iacute':   237, 'icirc':    238, 'iuml':     239,
      \ 'eth':      240, 'ntilde':   241, 'ograve':   242, 'oacute':   243,
      \ 'ocirc':    244, 'otilde':   245, 'ouml':     246, 'divide':   247,
      \ 'oslash':   248, 'ugrave':   249, 'uacute':   250, 'ucirc':    251,
      \ 'uuml':     252, 'yacute':   253, 'thorn':    254, 'yuml':     255,
      \ 'OElig':    338, 'oelig':    339, 'Scaron':   352, 'scaron':   353,
      \ 'Yuml':     376, 'circ':     710, 'tilde':    732, 'ensp':    8194,
      \ 'emsp':    8195, 'thinsp':  8201, 'zwnj':    8204, 'zwj':     8205,
      \ 'lrm':     8206, 'rlm':     8207, 'ndash':   8211, 'mdash':   8212,
      \ 'lsquo':   8216, 'rsquo':   8217, 'sbquo':   8218, 'ldquo':   8220,
      \ 'rdquo':   8221, 'bdquo':   8222, 'dagger':  8224, 'Dagger':  8225,
      \ 'permil':  8240, 'lsaquo':  8249, 'rsaquo':  8250, 'euro':    8364,
      \ 'fnof':     402, 'Alpha':    913, 'Beta':     914, 'Gamma':    915,
      \ 'Delta':    916, 'Epsilon':  917, 'Zeta':     918, 'Eta':      919,
      \ 'Theta':    920, 'Iota':     921, 'Kappa':    922, 'Lambda':   923,
      \ 'Mu':       924, 'Nu':       925, 'Xi':       926, 'Omicron':  927,
      \ 'Pi':       928, 'Rho':      929, 'Sigma':    931, 'Tau':      932,
      \ 'Upsilon':  933, 'Phi':      934, 'Chi':      935, 'Psi':      936,
      \ 'Omega':    937, 'alpha':    945, 'beta':     946, 'gamma':    947,
      \ 'delta':    948, 'epsilon':  949, 'zeta':     950, 'eta':      951,
      \ 'theta':    952, 'iota':     953, 'kappa':    954, 'lambda':   955,
      \ 'mu':       956, 'nu':       957, 'xi':       958, 'omicron':  959,
      \ 'pi':       960, 'rho':      961, 'sigmaf':   962, 'sigma':    963,
      \ 'tau':      964, 'upsilon':  965, 'phi':      966, 'chi':      967,
      \ 'psi':      968, 'omega':    969, 'thetasym': 977, 'upsih':    978,
      \ 'piv':      982, 'bull':    8226, 'hellip':  8230, 'prime':   8242,
      \ 'Prime':   8243, 'oline':   8254, 'frasl':   8260, 'weierp':  8472,
      \ 'image':   8465, 'real':    8476, 'trade':   8482, 'alefsym': 8501,
      \ 'larr':    8592, 'uarr':    8593, 'rarr':    8594, 'darr':    8595,
      \ 'harr':    8596, 'crarr':   8629, 'lArr':    8656, 'uArr':    8657,
      \ 'rArr':    8658, 'dArr':    8659, 'hArr':    8660, 'forall':  8704,
      \ 'part':    8706, 'exist':   8707, 'empty':   8709, 'nabla':   8711,
      \ 'isin':    8712, 'notin':   8713, 'ni':      8715, 'prod':    8719,
      \ 'sum':     8721, 'minus':   8722, 'lowast':  8727, 'radic':   8730,
      \ 'prop':    8733, 'infin':   8734, 'ang':     8736, 'and':     8743,
      \ 'or':      8744, 'cap':     8745, 'cup':     8746, 'int':     8747,
      \ 'there4':  8756, 'sim':     8764, 'cong':    8773, 'asymp':   8776,
      \ 'ne':      8800, 'equiv':   8801, 'le':      8804, 'ge':      8805,
      \ 'sub':     8834, 'sup':     8835, 'nsub':    8836, 'sube':    8838,
      \ 'supe':    8839, 'oplus':   8853, 'otimes':  8855, 'perp':    8869,
      \ 'sdot':    8901, 'lceil':   8968, 'rceil':   8969, 'lfloor':  8970,
      \ 'rfloor':  8971, 'lang':    9001, 'rang':    9002, 'loz':     9674,
      \ 'spades':  9824, 'clubs':   9827, 'hearts':  9829, 'diams':   9830,
      \ 'apos':      39}

" }}}2

function! s:xml_encode(str) abort
  let str = a:str
  let str = substitute(str,'&','\&amp;','g')
  let str = substitute(str,'<','\&lt;','g')
  let str = substitute(str,'>','\&gt;','g')
  let str = substitute(str,'"','\&quot;','g')
  let str = substitute(str,"'",'\&apos;','g')
  return str
endfunction

function! s:xml_entity_decode(str) abort
  let str = substitute(a:str,'\c&#\%(0*38\|x0*26\);','&amp;','g')
  let str = substitute(str,'\c&#\(\d\+\);','\=nr2char(submatch(1))','g')
  let str = substitute(str,'\c&#\(x\x\+\);','\=nr2char("0".submatch(1))','g')
  let str = substitute(str,'\c&apos;',"'",'g')
  let str = substitute(str,'\c&quot;','"','g')
  let str = substitute(str,'\c&gt;','>','g')
  let str = substitute(str,'\c&lt;','<','g')
  let str = substitute(str,'\C&\(\%(amp;\)\@!\w*\);','\=nr2char(get(g:unimpaired_html_entities,submatch(1),63))','g')
  return substitute(str,'\c&amp;','\&','g')
endfunction

function! s:xml_decode(str) abort
  let str = substitute(a:str,'<\%([[:alnum:]-]\+=\%("[^"]*"\|''[^'']*''\)\|.\)\{-\}>','','g')
  return s:xml_entity_decode(str)
endfunction

function! s:Transform(algorithm,type) abort
  let sel_save = &selection
  let cb_save = &clipboard
  set selection=inclusive clipboard-=unnamed clipboard-=unnamedplus
  let reg_save = exists('*getreginfo') ? getreginfo('@') : getreg('@')
  if a:type ==# 'line'
    silent exe "normal! '[V']y"
    let @@ = substitute(@@, "\n$", '', '')
  elseif a:type ==# 'block'
    silent exe "normal! `[\<C-V>`]y"
  else
    silent exe "normal! `[v`]y"
  endif
  if a:algorithm =~# '^\u\|#'
    let @@ = {a:algorithm}(@@)
  else
    let @@ = s:{a:algorithm}(@@)
  endif
  norm! gvp
  call setreg('@', reg_save)
  let &selection = sel_save
  let &clipboard = cb_save
endfunction

function! s:TransformOpfunc(type) abort
  return s:Transform(s:encode_algorithm, a:type)
endfunction

function! s:TransformSetup(algorithm) abort
  let s:encode_algorithm = a:algorithm
  let &opfunc = matchstr(expand('<sfile>'), '<SNR>\d\+_').'TransformOpfunc'
  return 'g@'
endfunction

function! UnimpairedMapTransform(algorithm, key) abort
  let name = tr(a:algorithm, '_', '-')
  exe 'nnoremap <expr> <Plug>unimpaired_'    .a:algorithm.' <SID>TransformSetup("'.a:algorithm.'")'
  exe 'xnoremap <expr> <Plug>unimpaired_'    .a:algorithm.' <SID>TransformSetup("'.a:algorithm.'")'
  exe 'nnoremap <expr> <Plug>unimpaired_line_'.a:algorithm.' <SID>TransformSetup("'.a:algorithm.'")."_"'
  exe 'nnoremap <expr> <Plug>(unimpaired-' . name . ') <SID>TransformSetup("'.a:algorithm.'")'
  exe 'xnoremap <expr> <Plug>(unimpaired-' . name . ') <SID>TransformSetup("'.a:algorithm.'")'
  exe 'nnoremap <expr> <Plug>(unimpaired-' . name . '-line) <SID>TransformSetup("'.a:algorithm.'")."_"'
  exe s:Map('n', a:key, '<Plug>(unimpaired-' . name . ')')
  exe s:Map('x', a:key, '<Plug>(unimpaired-' . name . ')')
  exe s:Map('n', a:key.a:key[strlen(a:key)-1], '<Plug>(unimpaired-' . name . '-line)')
  return ''
endfunction

exe UnimpairedMapTransform('string_encode','[y')
exe UnimpairedMapTransform('string_decode',']y')
exe UnimpairedMapTransform('string_encode','[C')
exe UnimpairedMapTransform('string_decode',']C')
exe UnimpairedMapTransform('url_encode','[u')
exe UnimpairedMapTransform('url_decode',']u')
exe UnimpairedMapTransform('xml_encode','[x')
exe UnimpairedMapTransform('xml_decode',']x')

" vim:set sw=2 sts=2:
