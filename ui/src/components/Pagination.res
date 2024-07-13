let getPagesLeft = activePage => {
  let pagesRef = ref([])
  if activePage > 3 {
    pagesRef := pagesRef.contents->Array.concat([activePage - 2])
  }
  if activePage > 2 {
    pagesRef := pagesRef.contents->Array.concat([activePage - 1])
  }
  pagesRef.contents
}

let getPagesRight = (activePage, numPages) => {
  let pagesRef = ref([])
  if activePage < numPages - 1 {
    pagesRef := pagesRef.contents->Array.concat([activePage + 1])
  }
  if activePage < numPages - 2 {
    pagesRef := pagesRef.contents->Array.concat([activePage + 2])
  }
  pagesRef.contents
}

let pageItem = (num, onChange) =>
  <span className="mx-3 cursor-pointer" key={num->Int.toString} onClick={_ => onChange(num)}>
    {num->Int.toString->React.string}
  </span>
let pageItemActive = num =>
  <span className="bg-gray-200 mx-3 cursor-default"> {num->Int.toString->React.string} </span>

let ellipsis = () => <span className="cursor-default text-xs"> {"..."->React.string} </span>

@react.component
let make = (~activePage, ~numPages, ~onChange) => {
  let leftPages = getPagesLeft(activePage)
  let rightPages = getPagesRight(activePage, numPages)

  let showDotsLeft = leftPages->Array.length > 0 && leftPages->Array.getUnsafe(0) > 2
  let showDotsRight =
    rightPages->Array.length > 0 &&
      rightPages->Array.getUnsafe(rightPages->Array.length - 1) < numPages - 1

  let showFirstPage = activePage != 1
  let showLastPage = activePage != numPages
  let showCurrentPage = numPages != 1
  if activePage > numPages {
    React.null
  } else {
    <div className="my-2">
      {showFirstPage ? pageItem(1, onChange) : React.null}
      {showDotsLeft ? ellipsis() : React.null}
      {leftPages->Array.map(p => pageItem(p, onChange))->React.array}
      {showCurrentPage ? pageItemActive(activePage) : React.null}
      {rightPages->Array.map(p => pageItem(p, onChange))->React.array}
      {showDotsRight ? ellipsis() : React.null}
      {showLastPage ? pageItem(numPages, onChange) : React.null}
    </div>
  }
}
